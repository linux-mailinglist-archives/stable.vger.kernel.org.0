Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5586AF044
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjCGS3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbjCGS3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B474A2F38
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD19EB819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438DBC4339E;
        Tue,  7 Mar 2023 18:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213337;
        bh=yJRhdchdQW1Hbz7d3LrQvf6r0W4y+XiRojcqxOzKb6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVgrvsPVyxbA7fK34qbvebOwgRkkCdUQRhJ3QaiZ7k/CEiKXi72K7IBl0WguOMaC7
         3fi5/Kbc7mNlGNU6f6fraUs0r86z4E5ZMx7FQLToowzvgiYDCRksa9DS4N6fVhIP/i
         PSy1BQ8bOSfY1819DhySKj/lTIsR0cvYBOEsmSFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 445/885] drivers: base: transport_class: fix resource leak when transport_add_device() fails
Date:   Tue,  7 Mar 2023 17:56:19 +0100
Message-Id: <20230307170021.789474968@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e5da06b27ff5a148e42265c8e306670a9d913969 ]

The normal call sequence of using transport class is:

Add path:
transport_setup_device()
  transport_setup_classdev()  // call sas_host_setup() here
transport_add_device()	      // if fails, need call transport_destroy_device()
transport_configure_device()

Remove path:
transport_remove_device()
  transport_remove_classdev  // call sas_host_remove() here
transport_destroy_device()

If transport_add_device() fails, need call transport_destroy_device()
to free memory, but in this case, ->remove() is not called, and the
resources allocated in ->setup() are leaked. So fix these leaks by
calling ->remove() in transport_add_class_device() if it returns error.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221115031638.3816551-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/transport_class.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index ccc86206e5087..09ee2a1e35bbd 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -155,12 +155,27 @@ static int transport_add_class_device(struct attribute_container *cont,
 				      struct device *dev,
 				      struct device *classdev)
 {
+	struct transport_class *tclass = class_to_transport_class(cont->class);
 	int error = attribute_container_add_class_device(classdev);
 	struct transport_container *tcont = 
 		attribute_container_to_transport_container(cont);
 
-	if (!error && tcont->statistics)
+	if (error)
+		goto err_remove;
+
+	if (tcont->statistics) {
 		error = sysfs_create_group(&classdev->kobj, tcont->statistics);
+		if (error)
+			goto err_del;
+	}
+
+	return 0;
+
+err_del:
+	attribute_container_class_device_del(classdev);
+err_remove:
+	if (tclass->remove)
+		tclass->remove(tcont, dev, classdev);
 
 	return error;
 }
-- 
2.39.2



