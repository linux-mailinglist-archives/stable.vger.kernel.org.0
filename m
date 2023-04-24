Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22C86ECE5A
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjDXNbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjDXNbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D28E7D80
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0740962336
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16042C433EF;
        Mon, 24 Apr 2023 13:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343051;
        bh=v1XyL3NmflixdwWGNBTxSEHkkwJBpp4WaNuyxfyX4Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/LpmZz7gChQXxDj0YCcCtI3ppykpFuj0Pm+1LnOikI5yu9hIu3qrhDyntzhhfY/d
         EAlH9e3dDiZ2KamNTPG5VvOv9rGW7+CL+HsbGhiJmQWsbU/AkMBLOrgf9HARhGDuym
         PrGb0GnGFR7+TE2AQT5c4qUAFoyMe+NJMsyUnKHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Rix <trix@redhat.com>,
        Brian Masney <bmasney@redhat.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 058/110] iio: light: tsl2772: fix reading proximity-diodes from device tree
Date:   Mon, 24 Apr 2023 15:17:20 +0200
Message-Id: <20230424131138.465503736@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <bmasney@redhat.com>

commit b1cb00d51e361cf5af93649917d9790e1623647e upstream.

tsl2772_read_prox_diodes() will correctly parse the properties from
device tree to determine which proximity diode(s) to read from, however
it didn't actually set this value on the struct tsl2772_settings. Let's
go ahead and fix that.

Reported-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/lkml/20230327120823.1369700-1-trix@redhat.com/
Fixes: 94cd1113aaa0 ("iio: tsl2772: add support for reading proximity led settings from device tree")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20230404011455.339454-1-bmasney@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2772.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -601,6 +601,7 @@ static int tsl2772_read_prox_diodes(stru
 			return -EINVAL;
 		}
 	}
+	chip->settings.prox_diode = prox_diode_mask;
 
 	return 0;
 }


