Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD1C6B0D40
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 16:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCHPpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 10:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjCHPpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 10:45:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A878A252B9
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 07:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678290178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zPHx6OPcFDQ0fIqlaO4BgplZt9QEHBkAhS4WokOj/A=;
        b=LgewbCHnSWwOziUZ7o0GvcR+hdO0z+ZlasVUiW5FfvNiLnGNOtcW7eF92FmckAuP1Nbtak
        PhFbSYCYclRIzBxycsiDiK3wp7jQRh/QmJWKcdrelaZsTWEBnTWDczhWjtNl/0v/6jRFYh
        8iWLhXLsst89npFMzdDszyYZeT+90LQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-v0-lDeqUOTyRu3RnlBU91Q-1; Wed, 08 Mar 2023 10:42:56 -0500
X-MC-Unique: v0-lDeqUOTyRu3RnlBU91Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8576F817078;
        Wed,  8 Mar 2023 15:42:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.195.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4A55492B04;
        Wed,  8 Mar 2023 15:42:53 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v4 1/3] usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()
Date:   Wed,  8 Mar 2023 16:42:42 +0100
Message-Id: <20230308154244.722337-2-hdegoede@redhat.com>
In-Reply-To: <20230308154244.722337-1-hdegoede@redhat.com>
References: <20230308154244.722337-1-hdegoede@redhat.com>
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
index f632350f6dcb..0623861c597b 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1329,7 +1329,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con;
-	u64 command;
+	u64 command, ntfy;
 	int ret;
 	int i;
 
@@ -1341,8 +1341,8 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable basic notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_reset;
@@ -1374,12 +1374,13 @@ static int ucsi_init(struct ucsi *ucsi)
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

