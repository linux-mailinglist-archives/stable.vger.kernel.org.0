Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946E76A550D
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 10:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjB1JD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 04:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjB1JD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 04:03:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0886A249
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 01:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677574991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3lDVx5EyW8EHBxlsNXvmLaT5gVCmKjh9/OEv2HDjKPY=;
        b=aQ8IpkXi03j0nS7Qn5KpNqlxn4aLl5bmRSTfd9t21RxU2RryBxEkcAHIk/WjphBRUL1BM1
        Zk6VC+smhF6R1foVjfBVSpFgnkrJ+GxPpusuyQB0HAjt6OgiO3s/7/U30uQPpmSwek9oZ6
        xIG2NEdJKtptvuCjWPnZg1JpDbstGj4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-rIhp-ksvMx6URfrbFAg2xw-1; Tue, 28 Feb 2023 04:03:07 -0500
X-MC-Unique: rIhp-ksvMx6URfrbFAg2xw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 674A385D063;
        Tue, 28 Feb 2023 09:03:07 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.194.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79D90492B0E;
        Tue, 28 Feb 2023 09:03:06 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()
Date:   Tue, 28 Feb 2023 10:03:03 +0100
Message-Id: <20230228090305.9335-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When ucsi_init() fails, ucsi->connector is NULL, yet in case of
ucsi_acpi we may still get events which cause the ucs_acpi code to call
ucsi_connector_change(), which then derefs the NULL ucsi->connector
pointer.

Fix this by adding a check for ucsi->connector being NULL, as is
already done in ucsi_resume() for similar reasons.

Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 1cf8947c6d66..e762897cb25a 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -842,7 +842,13 @@ static void ucsi_handle_connector_change(struct work_struct *work)
  */
 void ucsi_connector_change(struct ucsi *ucsi, u8 num)
 {
-	struct ucsi_connector *con = &ucsi->connector[num - 1];
+	struct ucsi_connector *con;
+
+	/* Check for ucsi_init() failure */
+	if (!ucsi->connector)
+		return;
+
+	con = &ucsi->connector[num - 1];
 
 	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
 		dev_dbg(ucsi->dev, "Bogus connector change event\n");
-- 
2.39.1

