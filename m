Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D32E66C902
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjAPQpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjAPQpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DBB2887C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:32:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FF7FB8106C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB04DC433EF;
        Mon, 16 Jan 2023 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886754;
        bh=IMhPDgoMua3/pfTr93a5hVT6RV/EuEvuU9h8g/LBjLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awPG8sW3epqXtMYsQk2J0vbkONsdUrQim0Ur+CBKLmzTD/ope1yXmdeNqutjeIV+M
         4jXOGT6ECBFIU/4AuUuTuOhmTPd3+h3uITeVWcXBdT97R9k9b9b8+IZ7ob6oRnJGdU
         cfXjIcdJAAADsNbIloBBR76iNZFxmJQA1Nof3+iQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Weiyang <wangweiyang2@huawei.com>,
        Aristeu Rozanski <aris@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 519/658] device_cgroup: Roll back to original exceptions after copy failure
Date:   Mon, 16 Jan 2023 16:50:07 +0100
Message-Id: <20230116154933.271638690@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Weiyang <wangweiyang2@huawei.com>

commit e68bfbd3b3c3a0ec3cf8c230996ad8cabe90322f upstream.

When add the 'a *:* rwm' entry to devcgroup A's whitelist, at first A's
exceptions will be cleaned and A's behavior is changed to
DEVCG_DEFAULT_ALLOW. Then parent's exceptions will be copyed to A's
whitelist. If copy failure occurs, just return leaving A to grant
permissions to all devices. And A may grant more permissions than
parent.

Backup A's whitelist and recover original exceptions after copy
failure.

Cc: stable@vger.kernel.org
Fixes: 4cef7299b478 ("device_cgroup: add proper checking when changing default behavior")
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Reviewed-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/device_cgroup.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -79,6 +79,17 @@ free_and_exit:
 	return -ENOMEM;
 }
 
+static void dev_exceptions_move(struct list_head *dest, struct list_head *orig)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	lockdep_assert_held(&devcgroup_mutex);
+
+	list_for_each_entry_safe(ex, tmp, orig, list) {
+		list_move_tail(&ex->list, dest);
+	}
+}
+
 /*
  * called under devcgroup_mutex
  */
@@ -601,11 +612,13 @@ static int devcgroup_update_access(struc
 	int count, rc = 0;
 	struct dev_exception_item ex;
 	struct dev_cgroup *parent = css_to_devcgroup(devcgroup->css.parent);
+	struct dev_cgroup tmp_devcgrp;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	memset(&ex, 0, sizeof(ex));
+	memset(&tmp_devcgrp, 0, sizeof(tmp_devcgrp));
 	b = buffer;
 
 	switch (*b) {
@@ -617,15 +630,27 @@ static int devcgroup_update_access(struc
 
 			if (!may_allow_all(parent))
 				return -EPERM;
-			dev_exception_clean(devcgroup);
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
-			if (!parent)
+			if (!parent) {
+				devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+				dev_exception_clean(devcgroup);
 				break;
+			}
 
+			INIT_LIST_HEAD(&tmp_devcgrp.exceptions);
+			rc = dev_exceptions_copy(&tmp_devcgrp.exceptions,
+						 &devcgroup->exceptions);
+			if (rc)
+				return rc;
+			dev_exception_clean(devcgroup);
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
-			if (rc)
+			if (rc) {
+				dev_exceptions_move(&devcgroup->exceptions,
+						    &tmp_devcgrp.exceptions);
 				return rc;
+			}
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			dev_exception_clean(&tmp_devcgrp);
 			break;
 		case DEVCG_DENY:
 			if (css_has_online_children(&devcgroup->css))


