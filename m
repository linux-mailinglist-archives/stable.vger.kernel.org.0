Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAA859D4F5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243695AbiHWIcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245696AbiHWIbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:31:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BA36D9E9;
        Tue, 23 Aug 2022 01:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72CA06134C;
        Tue, 23 Aug 2022 08:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BDEC433D7;
        Tue, 23 Aug 2022 08:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242508;
        bh=fy9Hbiarz6gfSjxp30zSLiolvV9NwPqMSdgxPIu22Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5GpuMdOFj+DsGEJpRjzQKo1PW+xjtU2khuXDVcH+QpBWDVPqeRgMaRkK4Q/P3xlm
         RhJjgb63LsmWiIGWHRZZQ/ZA6JYTPbcYBsv+MG33wWoLNkTpBfT0nFD9qGJko8CyLI
         06HdPHXZEEHcRqJSWNQ1dO6t6VCHoY2UwcgbdW4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.9 082/101] nios2: restarts apply only to the first sigframe we build...
Date:   Tue, 23 Aug 2022 10:03:55 +0200
Message-Id: <20220823080037.691744892@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 411a76b7219555c55867466c82d70ce928d6c9e1 upstream.

Fixes: b53e906d255d ("nios2: Signal handling support")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/nios2/kernel/signal.c
+++ b/arch/nios2/kernel/signal.c
@@ -261,6 +261,7 @@ static int do_signal(struct pt_regs *reg
 			regs->ea = restart_addr;
 			break;
 		}
+		regs->orig_r2 = -1;
 	}
 
 	if (get_signal(&ksig)) {


