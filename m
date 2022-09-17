Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B915BB7A5
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 12:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIQKHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 06:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIQKHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 06:07:23 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93031186E7;
        Sat, 17 Sep 2022 03:07:22 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 9379592009C; Sat, 17 Sep 2022 12:07:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 843B192009B;
        Sat, 17 Sep 2022 11:07:18 +0100 (BST)
Date:   Sat, 17 Sep 2022 11:07:18 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
cc:     Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 0/2] serial: 8250: Let drivers request full 16550A feature
 probing
Message-ID: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,HDRS_LCASE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

 A recent change has added a SERIAL_8250_16550A_VARIANTS option, which 
lets one request the 8250 driver not to probe for 16550A device features 
so as to reduce the driver's device startup time in virtual machines.  
This has turned out problematic to a more recent update for the OxSemi 
Tornado series PCIe devices, whose new baud rate generator handling code 
actually requires switching hardware into the enhanced mode for correct 
operation, which actually requires 16550A device features to have been 
probed for.

 This small patch series fixes the issue by letting individual device 
subdrivers to request full 16550A device feature probing by means of a 
flag regardless of the SERIAL_8250_16550A_VARIANTS setting chosen.

 The changes have been verified with an OXPCIe952 device, in the native 
UART mode and a 64-bit RISC-V system as well as in the legacy UART mode 
and a 32-bit x86 system.

 Credit to Anders for reporting this issue and then working through the 
resolution.

  Maciej
