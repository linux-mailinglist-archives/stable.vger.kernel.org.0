Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E336C1918
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjCTPai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjCTPaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:30:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442F5C173
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF58A6157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C909DC433EF;
        Mon, 20 Mar 2023 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325770;
        bh=oK5MJPzq1Xqz++Q9EthFW8wcKK8XobRv6OQhXVGxmWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytkwbhceajetvEFt3fcKcHU9Z12PM9GAdB2FNg9FAXJwQfTUQEGQeoTGT5JIvSWHe
         vDy8X0scTebrDEbzuF3BzkhVm9tOjnfMkd9zF24+H6l+Cm+u8vUyl3YZ1abildcuIo
         UnPhyP6fU9bJpDD0mxYUi/za5UJ0CfxZmtn9xfFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 098/211] hwmon: (adt7475) Display smoothing attributes in correct order
Date:   Mon, 20 Mar 2023 15:53:53 +0100
Message-Id: <20230320145517.399440506@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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
index 51b3d16c32233..77222c35a38ec 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -556,11 +556,11 @@ static ssize_t temp_st_show(struct device *dev, struct device_attribute *attr,
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



