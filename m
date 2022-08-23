Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB70859D7A7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbiHWJmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352035AbiHWJkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C37098D12;
        Tue, 23 Aug 2022 01:41:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E26BB81C20;
        Tue, 23 Aug 2022 08:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAAEC433D6;
        Tue, 23 Aug 2022 08:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244050;
        bh=QQ3eWDx/UzEsjdEWteiakKgZ4UiJlFvdIgg8vViaTng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTyJFXkkyLpMmy+oJ967M+6yy+U560kn+hElp9wjhYAoBiCPxN96jg+k8fRWqKaZ0
         JRB5lqsk8bjKNS++jtmAvhH1e6583RB4trVJOdjUEXZj0QsnQa7hnni4EunXRz5m8A
         yh0P5nmRUHVUARvcSbB3fca9VsOZLQAC8X1HE1HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.15 029/244] apparmor: fix absroot causing audited secids to begin with =
Date:   Tue, 23 Aug 2022 10:23:08 +0200
Message-Id: <20220823080100.032701834@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -1632,9 +1632,9 @@ int aa_label_snxprint(char *str, size_t
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
@@ -1896,7 +1896,8 @@ struct aa_label *aa_label_strn_parse(str
 	AA_BUG(!str);
 
 	str = skipn_spaces(str, n);
-	if (str == NULL || (*str == '=' && base != &root_ns->unconfined->label))
+	if (str == NULL || (AA_DEBUG_LABEL && *str == '_' &&
+			    base != &root_ns->unconfined->label))
 		return ERR_PTR(-EINVAL);
 
 	len = label_count_strn_entries(str, end - str);


