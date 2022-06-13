Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23530548908
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353198AbiFMMa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357717AbiFMM31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010C65A14D;
        Mon, 13 Jun 2022 04:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58434B80EAA;
        Mon, 13 Jun 2022 11:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE69C34114;
        Mon, 13 Jun 2022 11:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118375;
        bh=eVVGLClJE3cjfMM7K64saHd3yZhNqEe/Dyi1Il2NU1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbpvHDjXPOFXcU3DC4MjFuqFo5xRFqqnENsdrAG1K3wcpMyhB+0lpkDtDvJK9POrb
         UuZ3P+zIp8cITxbtw3ov+7yvNAkCE/ddRbGtJQ+EIvq7wMGP/qa8+QKsspzERZBhpk
         Oe/pOhIlzxaUpgX/O7OE9jrmV83DWp04d8G0lP68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/172] serial: txx9: Dont allow CS5-6
Date:   Mon, 13 Jun 2022 12:09:56 +0200
Message-Id: <20220613094859.052644494@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 79ac88655dc0551e3571ad16bdabdbe65d61553e ]

Only CS7 and CS8 are supported but CSIZE is not sanitized with
CS5 or CS6 to CS8.

Set CSIZE correctly so that userspace knows the effective value.
Incorrect CSIZE also results in miscalculation of the frame bits in
tty_get_char_size() or in its predecessor where the roughly the same
code is directly within uart_update_timeout().

Fixes: 1da177e4c3f4 (Linux-2.6.12-rc2)
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220519081808.3776-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_txx9.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index 7a07e7272de1..7beec331010c 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -644,6 +644,8 @@ serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
 	case CS6:	/* not supported */
 	case CS8:
 		cval |= TXX9_SILCR_UMODE_8BIT;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
 		break;
 	}
 
-- 
2.35.1



