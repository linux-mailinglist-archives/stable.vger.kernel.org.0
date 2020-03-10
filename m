Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBCF917F7DE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCJMmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbgCJMmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:42:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D811424686;
        Tue, 10 Mar 2020 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844173;
        bh=7OL4AFPNc81mHOb2IMNKSoCtKQCEzE2Bj2zoIQERSJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAA02GTQmr1c/BqvvJCCG/DPPFnjFHFJdEZS3XXUuons+DojAbHCsIH43rtEwjSfm
         mZEsHEoqHBYG+24PvxvYEew3qn8RMW0cnCzZcQlv2XLqXcG24Ea7DOMlCXmZh8rW/T
         CBSL04v2ZYqNLAX4KZWxVwcpsWbGqPtz0Ti1Q2Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1f4d90ead370d72e450b@syzkaller.appspotmail.com,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.4 20/72] audit: fix error handling in audit_data_to_entry()
Date:   Tue, 10 Mar 2020 13:38:33 +0100
Message-Id: <20200310123606.607697839@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit 2ad3e17ebf94b7b7f3f64c050ff168f9915345eb upstream.

Commit 219ca39427bf ("audit: use union for audit_field values since
they are mutually exclusive") combined a number of separate fields in
the audit_field struct into a single union.  Generally this worked
just fine because they are generally mutually exclusive.
Unfortunately in audit_data_to_entry() the overlap can be a problem
when a specific error case is triggered that causes the error path
code to attempt to cleanup an audit_field struct and the cleanup
involves attempting to free a stored LSM string (the lsm_str field).
Currently the code always has a non-NULL value in the
audit_field.lsm_str field as the top of the for-loop transfers a
value into audit_field.val (both .lsm_str and .val are part of the
same union); if audit_data_to_entry() fails and the audit_field
struct is specified to contain a LSM string, but the
audit_field.lsm_str has not yet been properly set, the error handling
code will attempt to free the bogus audit_field.lsm_str value that
was set with audit_field.val at the top of the for-loop.

This patch corrects this by ensuring that the audit_field.val is only
set when needed (it is cleared when the audit_field struct is
allocated with kcalloc()).  It also corrects a few other issues to
ensure that in case of error the proper error code is returned.

Cc: stable@vger.kernel.org
Fixes: 219ca39427bf ("audit: use union for audit_field values since they are mutually exclusive")
Reported-by: syzbot+1f4d90ead370d72e450b@syzkaller.appspotmail.com
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/auditfilter.c |   71 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -434,6 +434,7 @@ static struct audit_entry *audit_data_to
 	bufp = data->buf;
 	for (i = 0; i < data->field_count; i++) {
 		struct audit_field *f = &entry->rule.fields[i];
+		u32 f_val;
 
 		err = -EINVAL;
 
@@ -442,12 +443,12 @@ static struct audit_entry *audit_data_to
 			goto exit_free;
 
 		f->type = data->fields[i];
-		f->val = data->values[i];
+		f_val = data->values[i];
 
 		/* Support legacy tests for a valid loginuid */
-		if ((f->type == AUDIT_LOGINUID) && (f->val == AUDIT_UID_UNSET)) {
+		if ((f->type == AUDIT_LOGINUID) && (f_val == AUDIT_UID_UNSET)) {
 			f->type = AUDIT_LOGINUID_SET;
-			f->val = 0;
+			f_val = 0;
 			entry->rule.pflags |= AUDIT_LOGINUID_LEGACY;
 		}
 
@@ -463,7 +464,7 @@ static struct audit_entry *audit_data_to
 		case AUDIT_SUID:
 		case AUDIT_FSUID:
 		case AUDIT_OBJ_UID:
-			f->uid = make_kuid(current_user_ns(), f->val);
+			f->uid = make_kuid(current_user_ns(), f_val);
 			if (!uid_valid(f->uid))
 				goto exit_free;
 			break;
@@ -472,11 +473,12 @@ static struct audit_entry *audit_data_to
 		case AUDIT_SGID:
 		case AUDIT_FSGID:
 		case AUDIT_OBJ_GID:
-			f->gid = make_kgid(current_user_ns(), f->val);
+			f->gid = make_kgid(current_user_ns(), f_val);
 			if (!gid_valid(f->gid))
 				goto exit_free;
 			break;
 		case AUDIT_ARCH:
+			f->val = f_val;
 			entry->rule.arch_f = f;
 			break;
 		case AUDIT_SUBJ_USER:
@@ -489,11 +491,13 @@ static struct audit_entry *audit_data_to
 		case AUDIT_OBJ_TYPE:
 		case AUDIT_OBJ_LEV_LOW:
 		case AUDIT_OBJ_LEV_HIGH:
-			str = audit_unpack_string(&bufp, &remain, f->val);
-			if (IS_ERR(str))
+			str = audit_unpack_string(&bufp, &remain, f_val);
+			if (IS_ERR(str)) {
+				err = PTR_ERR(str);
 				goto exit_free;
-			entry->rule.buflen += f->val;
-
+			}
+			entry->rule.buflen += f_val;
+			f->lsm_str = str;
 			err = security_audit_rule_init(f->type, f->op, str,
 						       (void **)&f->lsm_rule);
 			/* Keep currently invalid fields around in case they
@@ -502,68 +506,71 @@ static struct audit_entry *audit_data_to
 				pr_warn("audit rule for LSM \'%s\' is invalid\n",
 					str);
 				err = 0;
-			}
-			if (err) {
-				kfree(str);
+			} else if (err)
 				goto exit_free;
-			} else
-				f->lsm_str = str;
 			break;
 		case AUDIT_WATCH:
-			str = audit_unpack_string(&bufp, &remain, f->val);
-			if (IS_ERR(str))
+			str = audit_unpack_string(&bufp, &remain, f_val);
+			if (IS_ERR(str)) {
+				err = PTR_ERR(str);
 				goto exit_free;
-			entry->rule.buflen += f->val;
-
-			err = audit_to_watch(&entry->rule, str, f->val, f->op);
+			}
+			err = audit_to_watch(&entry->rule, str, f_val, f->op);
 			if (err) {
 				kfree(str);
 				goto exit_free;
 			}
+			entry->rule.buflen += f_val;
 			break;
 		case AUDIT_DIR:
-			str = audit_unpack_string(&bufp, &remain, f->val);
-			if (IS_ERR(str))
+			str = audit_unpack_string(&bufp, &remain, f_val);
+			if (IS_ERR(str)) {
+				err = PTR_ERR(str);
 				goto exit_free;
-			entry->rule.buflen += f->val;
-
+			}
 			err = audit_make_tree(&entry->rule, str, f->op);
 			kfree(str);
 			if (err)
 				goto exit_free;
+			entry->rule.buflen += f_val;
 			break;
 		case AUDIT_INODE:
+			f->val = f_val;
 			err = audit_to_inode(&entry->rule, f);
 			if (err)
 				goto exit_free;
 			break;
 		case AUDIT_FILTERKEY:
-			if (entry->rule.filterkey || f->val > AUDIT_MAX_KEY_LEN)
+			if (entry->rule.filterkey || f_val > AUDIT_MAX_KEY_LEN)
 				goto exit_free;
-			str = audit_unpack_string(&bufp, &remain, f->val);
-			if (IS_ERR(str))
+			str = audit_unpack_string(&bufp, &remain, f_val);
+			if (IS_ERR(str)) {
+				err = PTR_ERR(str);
 				goto exit_free;
-			entry->rule.buflen += f->val;
+			}
+			entry->rule.buflen += f_val;
 			entry->rule.filterkey = str;
 			break;
 		case AUDIT_EXE:
-			if (entry->rule.exe || f->val > PATH_MAX)
+			if (entry->rule.exe || f_val > PATH_MAX)
 				goto exit_free;
-			str = audit_unpack_string(&bufp, &remain, f->val);
+			str = audit_unpack_string(&bufp, &remain, f_val);
 			if (IS_ERR(str)) {
 				err = PTR_ERR(str);
 				goto exit_free;
 			}
-			entry->rule.buflen += f->val;
-
-			audit_mark = audit_alloc_mark(&entry->rule, str, f->val);
+			audit_mark = audit_alloc_mark(&entry->rule, str, f_val);
 			if (IS_ERR(audit_mark)) {
 				kfree(str);
 				err = PTR_ERR(audit_mark);
 				goto exit_free;
 			}
+			entry->rule.buflen += f_val;
 			entry->rule.exe = audit_mark;
 			break;
+		default:
+			f->val = f_val;
+			break;
 		}
 	}
 


