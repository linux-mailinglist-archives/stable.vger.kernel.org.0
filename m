Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AA96ADC12
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 11:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCGKfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 05:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCGKfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 05:35:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA881ABD3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 02:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678185270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNXR6SjiZlp6z6+ghSo4oDjqzh1XcRhvPWaR1Ti8Dlk=;
        b=Ela1svFKiQvlFiBjBMMemV8r060R1cvIkH2XR7ZDwiCu6HMz4uc10rlpLNrV7GahIHnLpu
        YnKV9yHf8V1udvE9A0+pTHS3hVw+rSxWjYEJ7leuW4Bu7x4dXgVPTTt8kQfEV2zagpPe9E
        846o3iCCnGxd+9YTMVFk8wlT2qPsewI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-KAjR-xEtPGulTy-8gtC32A-1; Tue, 07 Mar 2023 05:34:24 -0500
X-MC-Unique: KAjR-xEtPGulTy-8gtC32A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EA303C14844;
        Tue,  7 Mar 2023 10:34:24 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.195.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E45040CF8EE;
        Tue,  7 Mar 2023 10:34:23 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3 1/3] usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()
Date:   Tue,  7 Mar 2023 11:34:19 +0100
Message-Id: <20230307103421.8686-2-hdegoede@redhat.com>
In-Reply-To: <20230307103421.8686-1-hdegoede@redhat.com>
References: <20230307103421.8686-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

Fix this by not setting ucsi->ntfy inside ucsi_init() until ucsi_init()
has succeeded, so that ucsi_connector_change() ignores the events
because UCSI_ENABLE_NTFY_CONNECTOR_CHANGE is not set in the ntfy mask.

Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217106
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Delay setting ucsi->ntfy in ucsi_init() instead of adding a NULL pointer
  check to ucsi_connector_change()

Changes in v3:
- Add Link tag to commitmsg
---
 drivers/usb/typec/ucsi/ucsi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 1cf8947c6d66..8cbbb002fefe 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1205,7 +1205,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con;
-	u64 command;
+	u64 command, ntfy;
 	int ret;
 	int i;
 
@@ -1217,8 +1217,8 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable basic notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_reset;
@@ -1250,12 +1250,13 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable all notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_ALL;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_ALL;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_unregister;
 
+	ucsi->ntfy = ntfy;
 	return 0;
 
 err_unregister:
-- 
2.39.1

