Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E97608A9F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiJVJDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiJVJCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:02:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38562FA5D4;
        Sat, 22 Oct 2022 01:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7E0660BB8;
        Sat, 22 Oct 2022 08:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE0EC433D6;
        Sat, 22 Oct 2022 08:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425801;
        bh=k3ZzKbC9zNarUtRLUEgprjT0EFS8qIm+is5xwTEYpXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/WyWtuJZlgKxqtVukjR7L1b9jq1tN5Zwvo2zlxXIZiGl9leGf7ogYJ0xNElu9Knm
         1wkrreNWRRILqZqzXUlY8iYn1mNhWGZImz885AsRdVaaVVpCdWSsA8XLY64GtQZts+
         ghFzZPx67KwW1ST2R1eA/GGPZD0qw2utjGYHOSvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 591/717] hwmon: (sht4x) do not overflow clamping operation on 32-bit platforms
Date:   Sat, 22 Oct 2022 09:27:50 +0200
Message-Id: <20221022072524.574695065@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit f9c0cf8f26de367c58e48b02b1cdb9c377626e6f ]

On 32-bit platforms, long is 32 bits, so (long)UINT_MAX is less than
(long)SHT4X_MIN_POLL_INTERVAL, which means the clamping operation is
bogus. Fix this by clamping at INT_MAX, so that the upperbound is the
same on all platforms.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20220924101151.4168414-1-Jason@zx2c4.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index c19df3ade48e..13ac2d8f22c7 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -129,7 +129,7 @@ static int sht4x_read_values(struct sht4x_data *data)
 
 static ssize_t sht4x_interval_write(struct sht4x_data *data, long val)
 {
-	data->update_interval = clamp_val(val, SHT4X_MIN_POLL_INTERVAL, UINT_MAX);
+	data->update_interval = clamp_val(val, SHT4X_MIN_POLL_INTERVAL, INT_MAX);
 
 	return 0;
 }
-- 
2.35.1



