Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C545C6B0D3D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 16:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjCHPpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 10:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbjCHPo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 10:44:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BB3241FB
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 07:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678290180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RPVa/J5Cl7M2LIQutNWuK1JrUlzAeTjMVNLtf2BCpTE=;
        b=ROHeQC0cC04PUQQUb5i+4rBwzugX6qRj5sd3Jw7yJPA5sVwf8bHSuRD2HI48Kqbw/kUals
        WT8Fokr7hsdEVQ3RKjUKRlX/9nT9e2+M89NnNfsr/kzHIWvy6lGOtNS7/clNovusbqVJZ6
        8uBUOSZpDl8E6Z9+wpOS2OHs8iSpTc0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-_N02oHL4PF2VkJt9L5qcuw-1; Wed, 08 Mar 2023 10:42:57 -0500
X-MC-Unique: _N02oHL4PF2VkJt9L5qcuw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD8EB87A381;
        Wed,  8 Mar 2023 15:42:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.195.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD479492B04;
        Wed,  8 Mar 2023 15:42:55 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v4 3/3] usb: ucsi_acpi: Increase the command completion timeout
Date:   Wed,  8 Mar 2023 16:42:44 +0100
Message-Id: <20230308154244.722337-4-hdegoede@redhat.com>
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

Commit 130a96d698d7 ("usb: typec: ucsi: acpi: Increase command
completion timeout value") increased the timeout from 5 seconds
to 60 seconds due to issues related to alternate mode discovery.

After the alternate mode discovery switch to polled mode
the timeout was reduced, but instead of being set back to
5 seconds it was reduced to 1 second.

This is causing problems when using a Lenovo ThinkPad X1 yoga gen7
connected over Type-C to a LG 27UL850-W (charging DP over Type-C).

When the monitor is already connected at boot the following error
is logged: "PPM init failed (-110)", /sys/class/typec is empty and
on unplugging the NULL pointer deref fixed earlier in this series
happens.

When the monitor is connected after boot the following error
is logged instead: "GET_CONNECTOR_STATUS failed (-110)".

Setting the timeout back to 5 seconds fixes both cases.

Fixes: e08065069fc7 ("usb: typec: ucsi: acpi: Reduce the command completion timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index ce0c8ef80c04..62206a6b8ea7 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -78,7 +78,7 @@ static int ucsi_acpi_sync_write(struct ucsi *ucsi, unsigned int offset,
 	if (ret)
 		goto out_clear_bit;
 
-	if (!wait_for_completion_timeout(&ua->complete, HZ))
+	if (!wait_for_completion_timeout(&ua->complete, 5 * HZ))
 		ret = -ETIMEDOUT;
 
 out_clear_bit:
-- 
2.39.1

