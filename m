Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5035550F429
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345201AbiDZIfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344928AbiDZIdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609F3434A0;
        Tue, 26 Apr 2022 01:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF9C061722;
        Tue, 26 Apr 2022 08:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B978C385AF;
        Tue, 26 Apr 2022 08:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961536;
        bh=06XDKZ6eGspf8eNJ01Fmut9oFMZHv1vvkWCZjqwZm/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHuJFSI0CL3z3Dj+IY2K3Vk3/46atQnTAL3ZB09zxlIulXG7OLbqFY0Z/12GKsXpi
         +btGX4oq9GHHzCZeaBMa1h94DWtu3yUtB6gUx3Q4RIqNcnu0Zzf8G1WOr4RmkFDMvx
         1bDB15XzA3Xn25E7bieU8X3QUtNyvb8LzSctJfy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich@synopsys.com>,
        Vineet Gupta <vgupta@kernel.org>
Subject: [PATCH 4.14 28/43] ARC: entry: fix syscall_trace_exit argument
Date:   Tue, 26 Apr 2022 10:21:10 +0200
Message-Id: <20220426081735.347616252@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich@synopsys.com>

commit b1c6ecfdd06907554518ec384ce8e99889d15193 upstream.

Function syscall_trace_exit expects pointer to pt_regs. However
r0 is also used to keep syscall return value. Restore pointer
to pt_regs before calling syscall_trace_exit.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/kernel/entry.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -191,6 +191,7 @@ tracesys_exit:
 	st  r0, [sp, PT_r0]     ; sys call return value in pt_regs
 
 	;POST Sys Call Ptrace Hook
+	mov r0, sp		; pt_regs needed
 	bl  @syscall_trace_exit
 	b   ret_from_exception ; NOT ret_from_system_call at is saves r0 which
 	; we'd done before calling post hook above


