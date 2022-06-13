Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9047E5495D8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359457AbiFMMJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358704AbiFMMHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:07:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B1C515BE;
        Mon, 13 Jun 2022 04:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5B4B80D3A;
        Mon, 13 Jun 2022 11:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B875C3411E;
        Mon, 13 Jun 2022 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118008;
        bh=gDBS5ivrfzV13GZedBnzpygN0y4DfOtxPoTKpGomeQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1L39Lug9eIS1hMaMO9SA58+KfRvynnjxfmRQ7yidNFVRPbEowzpAeiznQ/G+f/ZnK
         FM3GdCN2BjpmfrPmNAXlBScvTymKTJnJkSn7tvBu5GKLd8+sRv17HCKpjO3MJYgdzr
         Qss7Cbv+epsE3C7Gn6tT8P5XtYarkjM/fJvJoW1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 210/287] serial: st-asc: Sanitize CSIZE and correct PARENB for CS7
Date:   Mon, 13 Jun 2022 12:10:34 +0200
Message-Id: <20220613094930.230209297@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index 7971997cdead..ce35e3a131b1 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -540,10 +540,14 @@ static void asc_set_termios(struct uart_port *port, struct ktermios *termios,
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



