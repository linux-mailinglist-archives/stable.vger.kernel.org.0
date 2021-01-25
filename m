Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0AD304A75
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbhAZFEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730968AbhAYSxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 282EE2067B;
        Mon, 25 Jan 2021 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600783;
        bh=PPZ0MfUPWSy1AH5SxpOjJFEARfCKR9NukERrkOVpdPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUXqRJDDerGvSTqdicIujrl2E8EW5I+bouHfTqF4ERSejSTT2SgOtBx4RHm2C+Tu+
         xMU6GHBoQFpUzI7rYnB+cCNT0mTqdfIRwPYS+yMJNkIm5ZBYEyeVfVNOrjbK8WkLWQ
         tyS5WXuIaG1zMD0VhNuVsblSwbiTSLbyNb7X0Ok4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
Subject: [PATCH 5.10 149/199] cls_flower: call nla_ok() before nla_next()
Date:   Mon, 25 Jan 2021 19:39:31 +0100
Message-Id: <20210125183222.503822502@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

commit c96adff95619178e2118925578343ad54857c80c upstream.

fl_set_enc_opt() simply checks if there are still bytes left to parse,
but this is not sufficent as syzbot seems to be able to generate
malformatted netlink messages. nla_ok() is more strict so should be
used to validate the next nlattr here.

And nla_validate_nested_deprecated() has less strict check too, it is
probably too late to switch to the strict version, but we can just
call nla_ok() too after it.

Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20210115185024.72298-1-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/cls_flower.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1272,6 +1272,10 @@ static int fl_set_enc_opt(struct nlattr
 
 		nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
 		msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "Invalid nested attribute for masks");
+			return -EINVAL;
+		}
 	}
 
 	nla_for_each_attr(nla_opt_key, nla_enc_key,
@@ -1307,9 +1311,6 @@ static int fl_set_enc_opt(struct nlattr
 				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
 				return -EINVAL;
 			}
-
-			if (msk_depth)
-				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		case TCA_FLOWER_KEY_ENC_OPTS_VXLAN:
 			if (key->enc_opts.dst_opt_type) {
@@ -1340,9 +1341,6 @@ static int fl_set_enc_opt(struct nlattr
 				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
 				return -EINVAL;
 			}
-
-			if (msk_depth)
-				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
 			if (key->enc_opts.dst_opt_type) {
@@ -1373,14 +1371,20 @@ static int fl_set_enc_opt(struct nlattr
 				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
 				return -EINVAL;
 			}
-
-			if (msk_depth)
-				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
 			return -EINVAL;
 		}
+
+		if (!msk_depth)
+			continue;
+
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "A mask attribute is invalid");
+			return -EINVAL;
+		}
+		nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
 	}
 
 	return 0;


