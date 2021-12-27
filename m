Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C93948010B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbhL0Pwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241338AbhL0Puk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:50:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26E9C08E84C;
        Mon, 27 Dec 2021 07:46:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74BACB810D1;
        Mon, 27 Dec 2021 15:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EC9C36AEA;
        Mon, 27 Dec 2021 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619962;
        bh=TH9tliH2EpX4l3/PYkE8fv80lYhhk/caoEVvN70oEH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfQ41RqPxOf0e6htqqotNllTj0rQC6zYBTEehrMUgFMHCzDCJPeDh0sc7MpkfVoWb
         aYloL52kxKjdrPDJ513QAr1XAmk+dWddjDjc55wP47o8dgUo7b28XpNkox10z+vcqA
         ccbm24qeEr0HcEnjE7P6HKMYqH+QUemjgLWhyLHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 122/128] hwmon: (lm90) Do not report busy status bit as alarm
Date:   Mon, 27 Dec 2021 16:31:37 +0100
Message-Id: <20211227151335.597757547@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit cdc5287acad9ede121924a9c9313544b80d15842 upstream.

Bit 7 of the status register indicates that the chip is busy
doing a conversion. It does not indicate an alarm status.
Stop reporting it as alarm status bit.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/lm90.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -200,6 +200,7 @@ enum chips { lm90, adm1032, lm99, lm86,
 #define LM90_STATUS_RHIGH	(1 << 4) /* remote high temp limit tripped */
 #define LM90_STATUS_LLOW	(1 << 5) /* local low temp limit tripped */
 #define LM90_STATUS_LHIGH	(1 << 6) /* local high temp limit tripped */
+#define LM90_STATUS_BUSY	(1 << 7) /* conversion is ongoing */
 
 #define MAX6696_STATUS2_R2THRM	(1 << 1) /* remote2 THERM limit tripped */
 #define MAX6696_STATUS2_R2OPEN	(1 << 2) /* remote2 is an open circuit */
@@ -820,7 +821,7 @@ static int lm90_update_device(struct dev
 		val = lm90_read_reg(client, LM90_REG_R_STATUS);
 		if (val < 0)
 			return val;
-		data->alarms = val;	/* lower 8 bit of alarms */
+		data->alarms = val & ~LM90_STATUS_BUSY;
 
 		if (data->kind == max6696) {
 			val = lm90_select_remote_channel(data, 1);


