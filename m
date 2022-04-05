Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C027A4F318C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350728AbiDEJ7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344256AbiDEJTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8929B49929;
        Tue,  5 Apr 2022 02:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CB4CB818F3;
        Tue,  5 Apr 2022 09:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFBAC385A1;
        Tue,  5 Apr 2022 09:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149580;
        bh=YQBBt348QczuErmBCnsCv2Z8g7AXEkgPfyVRGt2m8CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pS5HMSq6hORKsUOeSudsTlf6284ZVXk20m6eO6f/88lRQF0+u4C/kKEZRQZdpooWu
         HDZtEEtdoQpAL7JrkYzg5niMtScpf/rkINtsEBOZ9neZUAIXoKr2LHo6JAPszuGP1A
         adnzhO4hUG8ttxcAJwi9hkuOJzwBWRdwRso5uIQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Haines <richard_c_haines@btinternet.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>
Subject: [PATCH 5.16 0767/1017] selinux: allow FIOCLEX and FIONCLEX with policy capability
Date:   Tue,  5 Apr 2022 09:28:00 +0200
Message-Id: <20220405070417.028121434@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Haines <richard_c_haines@btinternet.com>

[ Upstream commit 65881e1db4e948614d9eb195b8e1197339822949 ]

These ioctls are equivalent to fcntl(fd, F_SETFD, flags), which SELinux
always allows too.  Furthermore, a failed FIOCLEX could result in a file
descriptor being leaked to a process that should not have access to it.

As this patch removes access controls, a policy capability needs to be
enabled in policy to always allow these ioctls.

Based-on-patch-by: Demi Marie Obenour <demiobenour@gmail.com>
Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
[PM: subject line tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c                   | 6 ++++++
 security/selinux/include/policycap.h       | 1 +
 security/selinux/include/policycap_names.h | 3 ++-
 security/selinux/include/security.h        | 7 +++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 69b0709bd156..94ef617de9d0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3800,6 +3800,12 @@ static int selinux_file_ioctl(struct file *file, unsigned int cmd,
 					    CAP_OPT_NONE, true);
 		break;
 
+	case FIOCLEX:
+	case FIONCLEX:
+		if (!selinux_policycap_ioctl_skip_cloexec())
+			error = ioctl_has_perm(cred, file, FILE__IOCTL, (u16) cmd);
+		break;
+
 	/* default case assumes that the command will go
 	 * to the file's ioctl() function.
 	 */
diff --git a/security/selinux/include/policycap.h b/security/selinux/include/policycap.h
index 2ec038efbb03..a9e572ca4fd9 100644
--- a/security/selinux/include/policycap.h
+++ b/security/selinux/include/policycap.h
@@ -11,6 +11,7 @@ enum {
 	POLICYDB_CAPABILITY_CGROUPSECLABEL,
 	POLICYDB_CAPABILITY_NNP_NOSUID_TRANSITION,
 	POLICYDB_CAPABILITY_GENFS_SECLABEL_SYMLINKS,
+	POLICYDB_CAPABILITY_IOCTL_SKIP_CLOEXEC,
 	__POLICYDB_CAPABILITY_MAX
 };
 #define POLICYDB_CAPABILITY_MAX (__POLICYDB_CAPABILITY_MAX - 1)
diff --git a/security/selinux/include/policycap_names.h b/security/selinux/include/policycap_names.h
index b89289f092c9..ebd64afe1def 100644
--- a/security/selinux/include/policycap_names.h
+++ b/security/selinux/include/policycap_names.h
@@ -12,7 +12,8 @@ const char *selinux_policycap_names[__POLICYDB_CAPABILITY_MAX] = {
 	"always_check_network",
 	"cgroup_seclabel",
 	"nnp_nosuid_transition",
-	"genfs_seclabel_symlinks"
+	"genfs_seclabel_symlinks",
+	"ioctl_skip_cloexec"
 };
 
 #endif /* _SELINUX_POLICYCAP_NAMES_H_ */
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index ac0ece01305a..c0d966020ebd 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -219,6 +219,13 @@ static inline bool selinux_policycap_genfs_seclabel_symlinks(void)
 	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_GENFS_SECLABEL_SYMLINKS]);
 }
 
+static inline bool selinux_policycap_ioctl_skip_cloexec(void)
+{
+	struct selinux_state *state = &selinux_state;
+
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_IOCTL_SKIP_CLOEXEC]);
+}
+
 struct selinux_policy_convert_data;
 
 struct selinux_load_state {
-- 
2.34.1



