Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED47A6C163B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjCTPDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjCTPDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC74493D8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F313461591
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0BCC433EF;
        Mon, 20 Mar 2023 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324323;
        bh=GhIq9p3fhcBSqSWvatTGDVBKVJdhLIo5so0Hp5PKEnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA/VN+7PZ/MALx6CYeNLffHF6JAMqalnjQEeeyYsPAdRQuDeb110KD7uVDbzf1Prz
         cgnp5zXZ1rNo/mhV4Lo1FCY8utpTLwRkBb8EwDkkDMx16DrcxsE3FZwuxMahvVFJYv
         ja+0przHyrTnVjN6RWymbRdrDZzHG+OwiJjI1jxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/36] hwmon: (adt7475) Display smoothing attributes in correct order
Date:   Mon, 20 Mar 2023 15:54:43 +0100
Message-Id: <20230320145424.885008752@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>

[ Upstream commit 5f8d1e3b6f9b5971f9c06d5846ce00c49e3a8d94 ]

Throughout the ADT7475 driver, attributes relating to the temperature
sensors are displayed in the order Remote 1, Local, Remote 2.  Make
temp_st_show() conform to this expectation so that values set by
temp_st_store() can be displayed using the correct attribute.

Fixes: 8f05bcc33e74 ("hwmon: (adt7475) temperature smoothing")
Signed-off-by: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20230222005228.158661-2-tony.obrien@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7475.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 0a87c5b512862..bde5fe10a95a5 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -554,11 +554,11 @@ static ssize_t show_temp_st(struct device *dev, struct device_attribute *attr,
 		val = data->enh_acoustics[0] & 0xf;
 		break;
 	case 1:
-		val = (data->enh_acoustics[1] >> 4) & 0xf;
+		val = data->enh_acoustics[1] & 0xf;
 		break;
 	case 2:
 	default:
-		val = data->enh_acoustics[1] & 0xf;
+		val = (data->enh_acoustics[1] >> 4) & 0xf;
 		break;
 	}
 
-- 
2.39.2



