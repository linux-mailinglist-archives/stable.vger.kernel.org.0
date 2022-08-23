Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD1B59DF57
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243718AbiHWLwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358633AbiHWLu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ED2923FB;
        Tue, 23 Aug 2022 02:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86449612D6;
        Tue, 23 Aug 2022 09:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAC4C433C1;
        Tue, 23 Aug 2022 09:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247084;
        bh=RvjSZfdVXccz8CkWmcCeyG9PczJS9MftdpEwo4a8NfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxLeNf5kYss4G5C7IHkY1C2yOqBcr9mPNbkWg1CzaE6NsmInstgU8e7TCmrZ5bMXL
         wc+IlHsAy5m2IclPKwnkdh9Whz0AlTHbfm5/ne0IQE/Gnx5gGLmlJvmf/ZmjEO/uZ3
         hRhjsL8lfHfb60wdBqtNMp6kXP8K3dgnN9JG/5ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.4 295/389] apparmor: fix absroot causing audited secids to begin with =
Date:   Tue, 23 Aug 2022 10:26:13 +0200
Message-Id: <20220823080127.883579954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Johansen <john.johansen@canonical.com>

commit 511f7b5b835726e844a5fc7444c18e4b8672edfd upstream.

AppArmor is prefixing secids that are converted to secctx with the =
to indicate the secctx should only be parsed from an absolute root
POV. This allows catching errors where secctx are reparsed back into
internal labels.

Unfortunately because audit is using secid to secctx conversion this
means that subject and object labels can result in a very unfortunate
== that can break audit parsing.

eg. the subj==unconfined term in the below audit message

type=USER_LOGIN msg=audit(1639443365.233:160): pid=1633 uid=0 auid=1000
ses=3 subj==unconfined msg='op=login id=1000 exe="/usr/sbin/sshd"
hostname=192.168.122.1 addr=192.168.122.1 terminal=/dev/pts/1 res=success'

Fix this by switch the prepending of = to a _. This still works as a
special character to flag this case without breaking audit. Also move
this check behind debug as it should not be needed during normal
operqation.

Fixes: 26b7899510ae ("apparmor: add support for absolute root view based labels")
Reported-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/include/lib.h |    5 +++++
 security/apparmor/label.c       |    7 ++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/security/apparmor/include/lib.h
+++ b/security/apparmor/include/lib.h
@@ -22,6 +22,11 @@
  */
 
 #define DEBUG_ON (aa_g_debug)
+/*
+ * split individual debug cases out in preparation for finer grained
+ * debug controls in the future.
+ */
+#define AA_DEBUG_LABEL DEBUG_ON
 #define dbg_printk(__fmt, __args...) pr_debug(__fmt, ##__args)
 #define AA_DEBUG(fmt, args...)						\
 	do {								\
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1637,9 +1637,9 @@ int aa_label_snxprint(char *str, size_t
 	AA_BUG(!str && size != 0);
 	AA_BUG(!label);
 
-	if (flags & FLAG_ABS_ROOT) {
+	if (AA_DEBUG_LABEL && (flags & FLAG_ABS_ROOT)) {
 		ns = root_ns;
-		len = snprintf(str, size, "=");
+		len = snprintf(str, size, "_");
 		update_for_len(total, len, size, str);
 	} else if (!ns) {
 		ns = labels_ns(label);
@@ -1901,7 +1901,8 @@ struct aa_label *aa_label_strn_parse(str
 	AA_BUG(!str);
 
 	str = skipn_spaces(str, n);
-	if (str == NULL || (*str == '=' && base != &root_ns->unconfined->label))
+	if (str == NULL || (AA_DEBUG_LABEL && *str == '_' &&
+			    base != &root_ns->unconfined->label))
 		return ERR_PTR(-EINVAL);
 
 	len = label_count_strn_entries(str, end - str);


