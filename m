Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD573E4681
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhHIN0k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Aug 2021 09:26:40 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:57305 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbhHIN0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 09:26:40 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6C332CED47;
        Mon,  9 Aug 2021 15:26:18 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: regression: Bluetooth interface broken on systems with Mediatek
 CPU
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <a9cd03da-b816-eed3-7e77-d539924cbe88@roeck-us.net>
Date:   Mon, 9 Aug 2021 15:26:18 +0200
Cc:     regressions@lists.linux.dev, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7621B196-B25E-475C-8D6E-AE6CFDFF8183@holtmann.org>
References: <a9cd03da-b816-eed3-7e77-d539924cbe88@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

> [ Greg asked me to submit a report to regressions@, so here it is. ]
> 
> The following error was observed on Chromebooks with MT8183 CPU
> (ASUS Chromebook Detachable CM3, HP Chromebook 11a, and others):
> 
> [  224.735198] Bluetooth: qca_setup() hci0: setting up ROME/QCA6390
> [  225.205024] Bluetooth: qca_read_soc_version() hci0: QCA Product ID   :0x00000008
> [  225.205040] Bluetooth: qca_read_soc_version() hci0: QCA SOC Version  :0x00000044
> [  225.205045] Bluetooth: qca_read_soc_version() hci0: QCA ROM Version  :0x00000302
> [  225.205049] Bluetooth: qca_read_soc_version() hci0: QCA Patch Version:0x000003e8
> [  225.205055] Bluetooth: qca_uart_setup() hci0: QCA controller version 0x00440302
> [  225.205061] Bluetooth: qca_download_firmware() hci0: QCA Downloading qca/rampatch_00440302.bin
> [  227.252653] Bluetooth: hci_cmd_timeout() hci0: command 0xfc00 tx timeout
> ...
> [  223.604971] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)
> [  223.605027] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)
> (repeated several times)
> ...
> 
> The Bluetooth interface on those Chromebooks can not be enabled.
> 
> Bisect suggests that upstream commit 0ea9fd001a14 ("Bluetooth: Shutdown
> controller after workqueues are flushed or cancelled") introduced the problem.
> Reverting it fixes the problem.
> 
> The problem was also reported at [1] on a Mediatek Pumpkin board.
> 
> As of this writing, the problem is still present in the upstream kernel
> as well as in all stable releases which include commit 0ea9fd001a14.

post it to the linux-bluetooth@vger mailing list. This is Qualcomm driver
specific and maybe they broke something. However there is an ongoing
discussion about your bi-sected commit regarding Mediatek Bluetooth device
where this seems to also have caused a problem.

Regards

Marcel

