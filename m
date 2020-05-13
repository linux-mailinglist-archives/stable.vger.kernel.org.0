Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310CC1D0FAA
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbgEMKZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:25:24 -0400
Received: from mail.namespace.at ([213.208.148.235]:40934 "EHLO
        mail.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731466AbgEMKZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 06:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deduktiva.com; s=a; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=83dIodJhlCkWiD1JexrwDh4DNuHCVUIHIC9p5u2NCrQ=; b=b6nmtRDAR6jh84PXOgNGGLFHb0
        ZmInZF+/07GgZORyr9jp3KbEZLHi9Unbe2UOFa4QHnZesECTFTBZR4pwlDf3pzkV8HdHTJXx5YqjU
        kqo55apxDPz9IZAPpjcI6cNfoxtubzlh+02eGhT+O1NDlkec1tNpj7Xm0bCuHUoZV7tqVgEaUgjJp
        +bzx46DtF0ocIyHfwQaLfuDm0IyUV+bCNtoqFktZrwmYg1TMT5dtVw2asZaoMoz3muTedMMRj8AqF
        43ELYfpmGQC05mStRi8aV5EoJdgF9wXO3lzfdBNWkTkah49Rdb1CT+CF1G4MElfVNWdZZTU9hTViW
        4ejoYJ5Q==;
Date:   Wed, 13 May 2020 12:25:15 +0200
From:   Chris Hofstaedtler | Deduktiva <chris.hofstaedtler@deduktiva.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 03/12] lpfc: Fix broken Credit Recovery after driver load
Message-ID: <20200513102515.6uo2zbp455hupx7l@zeha.at>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
 <20200128002312.16346-4-jsmart2021@gmail.com>
 <20200512212855.36q2ut2io2cdtagn@zeha.at>
 <f75f508a-deaf-f0d3-b394-c4377f7848b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f75f508a-deaf-f0d3-b394-c4377f7848b5@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* James Smart <jsmart2021@gmail.com> [200513 02:00]:
> On 5/12/2020 2:28 PM, Chris Hofstaedtler wrote:
> > this commit, applied in Ubuntu's 5.4.0-30.34 tree as
> > 77d5805eafdb5c42bdfe78f058ad9c40ee1278b4, appears to cause our
> > HPE-branded 2-port 8Gb lpfcs to report FLOGI errors. Reverting it fixes target
> > discovery for me. See below for log messages and HW details.
> > 
> > ...
> > Let me know if you need further debug logs or something.
> > 
> > Thanks,
> > 
> 
> I'm more interested in what other patches you do or do not have in your
> tree.

To save everybody time figuring out patches, I've tried with a 5.7-rc tree
24085f70a6e1b0cb647ec92623284641d8270637, which gives these dmesg messages:

[    4.222975] Emulex LightPulse Fibre Channel SCSI driver 12.8.0.0
[    4.223864] scsi host2: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 07 device 00 irq 128
[    6.654380] scsi host4: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 07 device 01 irq 182
[    7.169041] lpfc 0000:07:00.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x20 x0 x0 x0 0
[    9.578752] lpfc 0000:07:00.1: 1:1303 Link Up Event x1 received Data: x1 xf7 x20 x0 x0 x0 0
[   27.225755] lpfc 0000:07:00.0: 0:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[   29.637644] lpfc 0000:07:00.1: 1:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[   47.275946] lpfc 0000:07:00.0: 0:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[   49.787867] lpfc 0000:07:00.1: 1:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[   67.356082] lpfc 0000:07:00.0: 0:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[   69.875049] lpfc 0000:07:00.1: 1:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[   87.401269] lpfc 0000:07:00.0: 0:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[   89.929189] lpfc 0000:07:00.1: 1:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[  105.533242] lpfc 0000:07:00.0: 0:(0):0237 Pending Link Event during Discovery: State x7
[  105.533546] lpfc 0000:07:00.0: 0:1305 Link Down Event x2 received Data: x2 x7 x98014 x0 x0
[  105.615008] lpfc 0000:07:00.0: 0:1303 Link Up Event x3 received Data: x3 x0 x20 x0 x0 x0 0
[  109.989341] lpfc 0000:07:00.1: 1:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
[  124.772701] lpfc 0000:07:00.0: 0:(0):2858 FLOGI failure Status:x3/x2 TMO:x10 Data x101000 x0
 
> This is the message that threw it to the left:
> 0237 Pending Link Event during Discovery
> 
> Let me look a little.
> 
> -- james

Best,
Chris

-- 
Chris Hofstaedtler / Deduktiva GmbH (FN 418592 b, HG Wien)
www.deduktiva.com / +43 1 353 1707
