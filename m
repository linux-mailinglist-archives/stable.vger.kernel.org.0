Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CAE549177
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354100AbiFMM0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350794AbiFMMYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44D3326C8;
        Mon, 13 Jun 2022 04:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30845613E9;
        Mon, 13 Jun 2022 11:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDA1C3411E;
        Mon, 13 Jun 2022 11:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118336;
        bh=KA4ckKEwTMQjAMAYZw3XIsMlaWXwigYBmOCaRpLBCGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hl23M0MDH8TMA6eALVbTr1qnAgoYO3kmqj488DxZXP1rtoetjfAqIDj3fjc0AOBXP
         d3JJvvB3J11NdLNwBW14keLuSLIWVeygRDtTnuoQBbx/3uN14WzhrPVoQFOy+kFFr2
         DzhLjklx18HzkVZf4CvMDVoJXj83NdD3lyCbRolU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/172] serial: st-asc: Sanitize CSIZE and correct PARENB for CS7
Date:   Mon, 13 Jun 2022 12:09:59 +0200
Message-Id: <20220613094859.757132852@linuxfoundation.org>
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

[ Upstream commit 52bb1cb7118564166b04d52387bd8403632f5190 ]

Only CS7 and CS8 seem supported but CSIZE is not sanitized from CS5 or
CS6 to CS8. In addition, ASC_CTL_MODE_7BIT_PAR suggests that CS7 has
to have parity, thus add PARENB.

Incorrect CSIZE results in miscalculation of the frame bits in
tty_get_char_size() or in its predecessor where the roughly the same
code is directly within uart_update_timeout().

Fixes: c4b058560762 (serial:st-asc: Add ST ASC driver.)
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220519081808.3776-8-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/st-asc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index e7048515a79c..97d36f870f64 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -535,10 +535,14 @@ static void asc_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* set character length */
 	if ((cflag & CSIZE) == CS7) {
 		ctrl_val |= ASC_CTL_MODE_7BIT_PAR;
+		cflag |= PARENB;
 	} else {
 		ctrl_val |= (cflag & PARENB) ?  ASC_CTL_MODE_8BIT_PAR :
 						ASC_CTL_MODE_8BIT;
+		cflag &= ~CSIZE;
+		cflag |= CS8;
 	}
+	termios->c_cflag = cflag;
 
 	/* set stop bit */
 	ctrl_val |= (cflag & CSTOPB) ? ASC_CTL_STOP_2BIT : ASC_CTL_STOP_1BIT;
-- 
2.35.1



