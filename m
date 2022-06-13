Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3718D5493B8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385665AbiFMOp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385692AbiFMOnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:43:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22853B2E9E;
        Mon, 13 Jun 2022 04:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C652B80D31;
        Mon, 13 Jun 2022 11:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D935FC34114;
        Mon, 13 Jun 2022 11:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121053;
        bh=cik2UWmz0PBmx+Cme4rzLA38B3Rv2FNtIkAKFF7lmls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXtNXjteSmjDubuuEOaEXgD8OQ6jukV/TPrGZ59/Q9ev4W4zz1KrXPaTZALNRUO4l
         wM+jwebksioC8rO6E3RSud3QQt2KsBfdWeuY45RyD7TPoFaryq5OG7EBKNETS5XrsP
         n1T2C/21kPq7CmDzBbvTBRyGkS2RGTDugDewaT+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jorge Lopez <jorge.lopez2@hp.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 255/298] platform/x86: hp-wmi: Fix hp_wmi_read_int() reporting error (0x05)
Date:   Mon, 13 Jun 2022 12:12:29 +0200
Message-Id: <20220613094932.812347505@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Lopez <jorge.lopez2@hp.com>

[ Upstream commit 12b19f14a21a2ee6348825d95b642ef2cd16794f ]

The purpose of this patch is to introduce a fix to hp_wmi_read_int()
and eliminate failure error (0x05). Several WMI queries leverage
hp_wmi_read_int() to read their data and were failing with error 0x05.

HPWMI_DISPLAY_QUERY
HPWMI_HDDTEMP_QUERY
HPWMI_ALS_QUERY
HPWMI_HARDWARE_QUERY
HPWMI_WIRELESS_QUERY
HPWMI_POSTCODEERROR_QUERY

The failure occurs because hp_wmi_read_int() calls
hp_wmi_perform_query() with input parameter of size greater than zero.
Invoking those WMI commands with an input buffer size greater than
zero causes the command to be rejected and error 0x05 be returned.

All changes were validated on a HP ZBook Workstation notebook,
HP EliteBook x360, and HP EliteBook 850 G8.

Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://lore.kernel.org/r/20220310210853.28367-2-jorge.lopez2@hp.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 88f0bfd6ecf1..29ae35d15a41 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -347,7 +347,7 @@ static int hp_wmi_read_int(int query)
 	int val = 0, ret;
 
 	ret = hp_wmi_perform_query(query, HPWMI_READ, &val,
-				   sizeof(val), sizeof(val));
+				   0, sizeof(val));
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
-- 
2.35.1



