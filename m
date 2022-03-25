Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDE44E75F0
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359722AbiCYPJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359640AbiCYPI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:08:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DDCDA08C;
        Fri, 25 Mar 2022 08:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56947B82833;
        Fri, 25 Mar 2022 15:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3B1C340EE;
        Fri, 25 Mar 2022 15:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220827;
        bh=LXjInEuRHsdH1yksMxpJd/ijOUbhpkKPDjHBTsBJpEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QY2xfuPGudYenp+0BuH1w1vRBUSbG625vfMsCqrDRMDFo6v86wfXNNIxKKpLxyA1R
         wZOeZShTKgV09qPsufzpZ+bglSns6qtbGz++p/dlSN1YvMKW7jNcJKvtVBO7x3Hkqx
         YCOl25ntbsViZk32p+VdF6pIhAmrcw34BclGIbO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Graute <oliver.graute@kococonnector.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 04/20] staging: fbtft: fb_st7789v: reset display before initialization
Date:   Fri, 25 Mar 2022 16:04:42 +0100
Message-Id: <20220325150417.138090246@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
References: <20220325150417.010265747@linuxfoundation.org>
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

From: Oliver Graute <oliver.graute@kococonnector.com>

commit b6821b0d9b56386d2bf14806f90ec401468c799f upstream.

In rare cases the display is flipped or mirrored. This was observed more
often in a low temperature environment. A clean reset on init_display()
should help to get registers in a sane state.

Fixes: ef8f317795da (staging: fbtft: use init function instead of init sequence)
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Graute <oliver.graute@kococonnector.com>
Link: https://lore.kernel.org/r/20220210085322.15676-1-oliver.graute@kococonnector.com
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fbtft/fb_st7789v.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/fbtft/fb_st7789v.c
+++ b/drivers/staging/fbtft/fb_st7789v.c
@@ -76,6 +76,8 @@ enum st7789v_command {
  */
 static int init_display(struct fbtft_par *par)
 {
+	par->fbtftops.reset(par);
+
 	/* turn off sleep mode */
 	write_reg(par, MIPI_DCS_EXIT_SLEEP_MODE);
 	mdelay(120);


