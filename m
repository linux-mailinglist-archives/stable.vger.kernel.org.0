Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D474565BC04
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbjACISV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbjACISA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:18:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ABCDFCD
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D9F66CE1048
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC73C433EF;
        Tue,  3 Jan 2023 08:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733848;
        bh=sIPRo/oSmNWoWPeYfHPYAX5jTaG69+5MW9c3q+JpSMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvDccvrutz42KNkuELUdwsAd7cQHV278qdvl2QFqeN96y6ZjLWcfTfpz/x4kU1TMo
         lzFsvc3N+dvkBi9fsjsaARej9BueH1UCgxFY+9fyRfdsJfN+4tnXgMyW+5hbZsswqh
         AVxkICBHWZFVCbQAG/+9XKLPFzJz8lk0CHkiJ7p0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.10 42/63] ARC: unbork 5.11 bootup: fix snafu in _TIF_NOTIFY_SIGNAL handling
Date:   Tue,  3 Jan 2023 09:14:12 +0100
Message-Id: <20230103081311.114689216@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit bb12433bf56e76789c6b08b36c546f745a6aa6e1 ]

Linux 5.11.rcX was failing to boot on ARC HSDK board. Turns out we have
a couple of issues, this being the first one, and I'm to blame as I
didn't pay attention during review.

TIF_NOTIFY_SIGNAL support requires checking multiple TIF_* bits in
kernel return code path. Old code only needed to check a single bit so
BBIT0 <TIF_SIGPENDING> worked. New code needs to check multiple bits so
AND <bit-mask> instruction. So needs to use bit mask variant _TIF_SIGPENDING

Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 53855e12588743ea128 ("arc: add support for TIF_NOTIFY_SIGNAL")
Link: https://github.com/foss-for-synopsys-dwc-arc-processors/linux/issues/34
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -308,7 +308,7 @@ resume_user_mode_begin:
 	mov r0, sp	; pt_regs for arg to do_signal()/do_notify_resume()
 
 	GET_CURR_THR_INFO_FLAGS   r9
-	and.f  0,  r9, TIF_SIGPENDING|TIF_NOTIFY_SIGNAL
+	and.f  0,  r9, _TIF_SIGPENDING|_TIF_NOTIFY_SIGNAL
 	bz .Lchk_notify_resume
 
 	; Normal Trap/IRQ entry only saves Scratch (caller-saved) regs


