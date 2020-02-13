Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59ECF15C3C6
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbgBMPoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729493AbgBMP1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:45 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF36224670;
        Thu, 13 Feb 2020 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607665;
        bh=rRVGBJoAk4p4b9bDiH9vGGzq0KWGMCjQPhZI4jrpP8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUn2bypk6DAnv9HmuFoKttHAMaxbB+QSZgEp2y6ZDIQFS0rFVNFsHJbDxMAFXT+zG
         thDgl+5IpSvOQ6GO9y5vGheXzqylvo5FswpInl2cMrsmBQNMWAkXgLmlu3+pFVyPFB
         G/tTdlJqHI7AIq7P2BsRFsoS6bAt8y8zy6XLLCnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 85/96] selinux: revert "stop passing MAY_NOT_BLOCK to the AVC upon follow_link"
Date:   Thu, 13 Feb 2020 07:21:32 -0800
Message-Id: <20200213151911.147099125@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

commit 1a37079c236d55fb31ebbf4b59945dab8ec8764c upstream.

This reverts commit e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK
to the AVC upon follow_link"). The correct fix is to instead fall
back to ref-walk if audit is required irrespective of the specific
audit data type.  This is done in the next commit.

Fixes: e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK to the AVC upon follow_link")
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/avc.c         |   24 ++++++++++++++++++++++--
 security/selinux/hooks.c       |    5 +++--
 security/selinux/include/avc.h |    5 +++++
 3 files changed, 30 insertions(+), 4 deletions(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -862,8 +862,9 @@ static int avc_update_node(struct selinu
 	 * permissive mode that only appear when in enforcing mode.
 	 *
 	 * See the corresponding handling in slow_avc_audit(), and the
-	 * logic in selinux_inode_permission for the MAY_NOT_BLOCK flag,
-	 * which is transliterated into AVC_NONBLOCKING.
+	 * logic in selinux_inode_follow_link and selinux_inode_permission
+	 * for the VFS MAY_NOT_BLOCK flag, which is transliterated into
+	 * AVC_NONBLOCKING for avc_has_perm_noaudit().
 	 */
 	if (flags & AVC_NONBLOCKING)
 		return 0;
@@ -1203,6 +1204,25 @@ int avc_has_perm(struct selinux_state *s
 	if (rc2)
 		return rc2;
 	return rc;
+}
+
+int avc_has_perm_flags(struct selinux_state *state,
+		       u32 ssid, u32 tsid, u16 tclass, u32 requested,
+		       struct common_audit_data *auditdata,
+		       int flags)
+{
+	struct av_decision avd;
+	int rc, rc2;
+
+	rc = avc_has_perm_noaudit(state, ssid, tsid, tclass, requested,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
+				  &avd);
+
+	rc2 = avc_audit(state, ssid, tsid, tclass, requested, &avd, rc,
+			auditdata, flags);
+	if (rc2)
+		return rc2;
+	return rc;
 }
 
 u32 avc_policy_seqno(struct selinux_state *state)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3008,8 +3008,9 @@ static int selinux_inode_follow_link(str
 	if (IS_ERR(isec))
 		return PTR_ERR(isec);
 
-	return avc_has_perm(&selinux_state,
-			    sid, isec->sid, isec->sclass, FILE__READ, &ad);
+	return avc_has_perm_flags(&selinux_state,
+				  sid, isec->sid, isec->sclass, FILE__READ, &ad,
+				  rcu ? MAY_NOT_BLOCK : 0);
 }
 
 static noinline int audit_inode_permission(struct inode *inode,
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -153,6 +153,11 @@ int avc_has_perm(struct selinux_state *s
 		 u32 ssid, u32 tsid,
 		 u16 tclass, u32 requested,
 		 struct common_audit_data *auditdata);
+int avc_has_perm_flags(struct selinux_state *state,
+		       u32 ssid, u32 tsid,
+		       u16 tclass, u32 requested,
+		       struct common_audit_data *auditdata,
+		       int flags);
 
 int avc_has_extended_perms(struct selinux_state *state,
 			   u32 ssid, u32 tsid, u16 tclass, u32 requested,


