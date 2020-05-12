Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3851D00EF
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 23:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbgELVfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 17:35:36 -0400
Received: from mail.namespace.at ([213.208.148.235]:38212 "EHLO
        mail.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgELVfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 17:35:36 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2020 17:35:34 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deduktiva.com; s=a; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=89R+I3Nv7OoCwz8O8Y54aGE2z5VkV6QrCU8YbhHz6xo=; b=zKaOJ+npDkNXXDEnk53Q45lxY9
        L+TqqOKXMugQYZpxZD3IXZ1X5Y67B/Xuo5RVVOdQh1VQjx1o9BcTfU6gbx0szYvY/gTkztZlO6uov
        ifKocjLZbiUlcuyV9lXBnY5KUY2vhtZkzTgOkBos5Ca5otIMYPZ+zeQHYf9zVftSUxc48At8D2bwA
        7n52DGNOuZ/p+/rQg0em8gLbT4B4L/Ae8UtwnHVqcxUFujaR4ykzYs0/2a/i592KtQmQSHyBwVIj2
        fPzjnIrEDjZbS9faSTywbViS85MPI4jQqA9TnLZabFNRXkO/8Juom9bwut7QZQddiYz6dpKfY3tUh
        6DZkttqw==;
Date:   Tue, 12 May 2020 23:28:55 +0200
From:   Chris Hofstaedtler <chris.hofstaedtler@deduktiva.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 03/12] lpfc: Fix broken Credit Recovery after driver load
Message-ID: <20200512212855.36q2ut2io2cdtagn@zeha.at>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
 <20200128002312.16346-4-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200128002312.16346-4-jsmart2021@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this commit, applied in Ubuntu's 5.4.0-30.34 tree as
77d5805eafdb5c42bdfe78f058ad9c40ee1278b4, appears to cause our
HPE-branded 2-port 8Gb lpfcs to report FLOGI errors. Reverting it fixes target
discovery for me. See below for log messages and HW details.

* James Smart <jsmart2021@gmail.com> [700101 01:00]:
> When driver is set to enable bb credit recovery, the switch displayed
> the setting as inactive.  If the link bounces, it switches to Active.

[..]

> Fixes: 6bfb16208298 ("scsi: lpfc: Fix configuration of BB credit recovery in service parameters")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

Broken log messages:

[    5.837826] Emulex LightPulse Fibre Channel SCSI driver 12.6.0.4
[    5.837827] Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.
[    5.838807] scsi host2: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 07 device 00 irq 128
[    8.300583] scsi host4: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 07 device 01 irq 182
[    8.858018] lpfc 0000:07:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x20 x0 x0 x0 0
[   11.380022] lpfc 0000:07:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x20 x0 x0 x0 0
[   28.819755] lpfc 0000:07:00.1: 1:(0):0237 Pending Link Event during Discovery: State x7
[   28.819963] lpfc 0000:07:00.1: 1:1305 Link Down Event x2 received Data: x2 x7 x98014 x0 x0
[   28.915823] lpfc 0000:07:00.1: 1:1303 Link Up Event x3 received Data: x3 x0 x20 x0 x0 x0 0
[   28.920083] lpfc 0000:07:00.0: 0:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0

Reverted:

[   74.838109] Emulex LightPulse Fibre Channel SCSI driver 12.6.0.4-7fbb1b050a65
[   74.838111] Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.
[   74.840310] scsi host2: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 07 device 00 irq 128
[   77.272319] scsi host4: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 07 device 01 irq 182
[   77.813387] lpfc 0000:07:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x20 x0 x0 x0 0
[   80.261594] lpfc 0000:07:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x20 x0 x0 x0 0
(plus various sd attach messages)

systool info:

    active_fc4s         = "0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 "
    dev_loss_tmo        = "30"
    max_npiv_vports     = "255"
    maxframe_size       = "2048 bytes"
    npiv_vports_inuse   = "0"
    port_id             = "0x0b0260"
    port_state          = "Online"
    port_type           = "NPort (fabric via point-to-point)"
    speed               = "8 Gbit"
    supported_classes   = "Class 3"
    supported_fc4s      = "0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 "
    supported_speeds    = "2 Gbit, 4 Gbit, 8 Gbit"
    symbolic_name       = "Emulex AJ763B/AH403A FV2.10X6 DV12.6.0.4-7fbb1b050a65 HN:pm01-vh03 OS:Linux"
    tgtid_bind_type     = "wwpn (World Wide Port Name)"

Let me know if you need further debug logs or something.

Thanks,
-- 
Chris Hofstaedtler / Deduktiva GmbH (FN 418592 b, HG Wien)
www.deduktiva.com / +43 1 353 1707
