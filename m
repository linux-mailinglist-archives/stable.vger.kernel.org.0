Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED03E579B1F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239622AbiGSMZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbiGSMYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDC261DA0;
        Tue, 19 Jul 2022 05:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91DAE6173C;
        Tue, 19 Jul 2022 12:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72826C341C6;
        Tue, 19 Jul 2022 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232510;
        bh=Z5YrrhxMm8za0uYKI6qSlgLlgLKeej1KH6n3JakE+V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZpFSBMbiqU93rC7b02lgGRhHDlzrH+Bki2NHQjwAmBipXQX4kUrsLqeFZngbr5jg
         9Q5NhXD3QsBtT5t+g0jVAAtgWdO+cbMaJPWzlc/qjas0dfjiBfJaf9nGDrU0QeywH/
         XqaR7GFyvL0ZNJIujNn8CzUfOIDnGvAcPWaeSsBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jorge Lopez <jorge.lopez2@hp.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/112] platform/x86: hp-wmi: Ignore Sanitization Mode event
Date:   Tue, 19 Jul 2022 13:54:15 +0200
Message-Id: <20220719114634.523603525@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
index e94e59283ecb..012639f6d335 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -62,6 +62,7 @@ enum hp_wmi_event_ids {
 	HPWMI_BACKLIT_KB_BRIGHTNESS	= 0x0D,
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
+	HPWMI_SANITIZATION_MODE		= 0x17,
 };
 
 struct bios_args {
@@ -629,6 +630,8 @@ static void hp_wmi_notify(u32 value, void *context)
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



