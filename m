Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9B5799D9
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbiGSMHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238255AbiGSMHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:07:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA314E63A;
        Tue, 19 Jul 2022 05:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 521B1B81B2D;
        Tue, 19 Jul 2022 12:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938F8C36AE2;
        Tue, 19 Jul 2022 12:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232067;
        bh=3wNf9MU5nkqkVJi/QAPuv9CYhltkS5PKt+M/rdroE8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHhQbLUdV7CnkJdso3l8zCG7q0dODczTaFdI00DNQbRGLy7O26sdf4UpKlAw2driC
         /qrgpaqjtsOmPa7tbJ5WLilAunOfile9Fw7ciIjp6Ag+FPfFrCnlcfPg9Rjanvrnul
         Gds+KXeQjaCbwoUCjnWAKAPjQYBAoUcDHeKP4pHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jorge Lopez <jorge.lopez2@hp.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/48] platform/x86: hp-wmi: Ignore Sanitization Mode event
Date:   Tue, 19 Jul 2022 13:54:08 +0200
Message-Id: <20220719114522.657993635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 9ab762a84b8094540c18a170e5ddd6488632c456 ]

After system resume the hp-wmi driver may complain:
[ 702.620180] hp_wmi: Unknown event_id - 23 - 0x0

According to HP it means 'Sanitization Mode' and it's harmless to just
ignore the event.

Cc: Jorge Lopez <jorge.lopez2@hp.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20220628123726.250062-1-kai.heng.feng@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 93fadd4abf14..f911410bb4c7 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -75,6 +75,7 @@ enum hp_wmi_event_ids {
 	HPWMI_BACKLIT_KB_BRIGHTNESS	= 0x0D,
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
+	HPWMI_SANITIZATION_MODE		= 0x17,
 };
 
 struct bios_args {
@@ -631,6 +632,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_BATTERY_CHARGE_PERIOD:
 		break;
+	case HPWMI_SANITIZATION_MODE:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
-- 
2.35.1



