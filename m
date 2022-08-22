Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40FC59BB12
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiHVIHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiHVIGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:06:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CA9EE30
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FDD460B06
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9232DC433D7;
        Mon, 22 Aug 2022 08:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661155576;
        bh=Twq6SiiDJ0QCIhKHIKf/gkaiH4kBUcet1BocaLxyjo0=;
        h=Subject:To:Cc:From:Date:From;
        b=CGFbW/5dPClVUGKk8eZD0CYw9zGA+a2PqUlnyB2Qh3GGDKaAwvggAoANpVH2a92C9
         /K4bewwDDzzDmqKMiY+aVo9ovEPoI8fsImoP6DRhk8uNIPmID72XSbok1uhPpBgrRn
         gv/AF6/GAAu8tYAteU1cyBk06TkZprezoSggrn0o=
Subject: FAILED: patch "[PATCH] apparmor: fix absroot causing audited secids to begin with =" failed to apply to 4.14-stable tree
To:     john.johansen@canonical.com, casey@schaufler-ca.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:06:13 +0200
Message-ID: <1661155573231188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 511f7b5b835726e844a5fc7444c18e4b8672edfd Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Tue, 14 Dec 2021 02:59:28 -0800
Subject: [PATCH] apparmor: fix absroot causing audited secids to begin with =

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

diff --git a/security/apparmor/include/lib.h b/security/apparmor/include/lib.h
index e2e8df0c6f1c..f42359f58eb5 100644
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
diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 0b0265da1926..4bdb558696e8 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1631,9 +1631,9 @@ int aa_label_snxprint(char *str, size_t size, struct aa_ns *ns,
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
@@ -1895,7 +1895,8 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
 	AA_BUG(!str);
 
 	str = skipn_spaces(str, n);
-	if (str == NULL || (*str == '=' && base != &root_ns->unconfined->label))
+	if (str == NULL || (AA_DEBUG_LABEL && *str == '_' &&
+			    base != &root_ns->unconfined->label))
 		return ERR_PTR(-EINVAL);
 
 	len = label_count_strn_entries(str, end - str);

