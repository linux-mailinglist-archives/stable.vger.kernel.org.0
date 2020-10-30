Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7E2A0691
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgJ3Ngj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 09:36:39 -0400
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:10065 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgJ3Ngj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 09:36:39 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2020 09:36:38 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1604064998;
  h=to:cc:from:subject:message-id:date:mime-version:
   content-transfer-encoding;
  bh=KBYxPOJGGLwUT0O6/I2IiveQzvncg3KM6YVoF9uYInk=;
  b=QoqvxxOsBxh3Ot7r1ikaliR0qyJtnq4odIH65gD5tuLzkhxXtzT1Zz+I
   P7mw17xAlH6MzPB5U2AEcmoZpd+DzByuM19oTZPERye/JcvyypB0Nde0/
   0Y/j1zlS6QrmQ5g+NFrB/QXMTtbQrFCd6Daohf84tEbTnQKBc6BOPfWLi
   w=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: joFkeRQlBggFFMu71lhDWwR9DsxeA3ZcFj6RfQ6ye1JE+2XOiuApp5aOpDGf4GAzy16nGytExt
 0lCm/GwLVlQrc33NZ5xBRq2VEh/IpNKVpM3jJqY679OScJq6W49w4xcVTsr1Dc8vS8TSQbiKGR
 B+C1olLmgGVqc0qiT29IPAHKTRTfp2Yi89t+eAfv6b5Xv+qhJP7qK5VxGgUUugGqpX/joWPrBb
 htBwmbDDis/cKsYoVnTRmO0nIZTGq+E1eB/OUNKE8glomVYG07RZ7fQwFFT0T95bfwS0MNy1Gi
 Srk=
X-SBRS: None
X-MesageID: 30397486
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.77,433,1596513600"; 
   d="scan'208";a="30397486"
To:     <stable@vger.kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: Stable backport request for "xen/events: don't use chip_data for
 legacy IRQs"
Message-ID: <0e4837c4-b750-4889-bb8c-8a36c73c7110@citrix.com>
Date:   Fri, 30 Oct 2020 13:29:28 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please backport [1] to 4.4, 4.9, 4.14, 4.19.

It fixes a commit that has been backported to all the current stable releases but for some reason the fixup was only backported to 5.4 & 5.8.

Debian 9 no longer boots as a Xen HVM guest because it is missing the fixup patch.

Thanks,
Ross

[1]:

commit 0891fb39ba67bd7ae023ea0d367297ffff010781
Author: Juergen Gross <jgross@suse.com>
Date:   Wed Sep 30 11:16:14 2020 +0200

    xen/events: don't use chip_data for legacy IRQs

    Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
    Xen is using the chip_data pointer for storing IRQ specific data. When
    running as a HVM domain this can result in problems for legacy IRQs, as
    those might use chip_data for their own purposes.

    Use a local array for this purpose in case of legacy IRQs, avoiding the
    double use.

    Cc: stable@vger.kernel.org
    Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
    Signed-off-by: Juergen Gross <jgross@suse.com>
    Tested-by: Stefan Bader <stefan.bader@canonical.com>
    Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
    Link: https://lore.kernel.org/r/20200930091614.13660-1-jgross@suse.com
    Signed-off-by: Juergen Gross <jgross@suse.com>
