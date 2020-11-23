Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23A92BFED2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 04:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKWDrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 22:47:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgKWDra (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 22:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606103249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RBxcPYH+vdk8Hh+y1ztx/6aT2W6/WgcV8+UQyj1Byj0=;
        b=SZe0rTUXRPqsUpJtXHgevJQFgA28wfocM6gdyPnFnrVeKiv6TsIb3prtPfmIqenZEnj/XZ
        f9/kLS+bZZMSHwNRJ8/ADtqrXUNDyMWEXLE6g26wj6EmHk1fEsyBtuWyrtCn32hkcwzfvX
        208hXdHu5K7uYmpFELRET2FEZWtpmbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-QHdtGe_NPWCUZAllIfaYtg-1; Sun, 22 Nov 2020 22:47:25 -0500
X-MC-Unique: QHdtGe_NPWCUZAllIfaYtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1E61809DE3;
        Mon, 23 Nov 2020 03:47:20 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-12-80.pek2.redhat.com [10.72.12.80])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FE655C1C4;
        Mon, 23 Nov 2020 03:47:09 +0000 (UTC)
Date:   Mon, 23 Nov 2020 11:47:05 +0800
From:   Dave Young <dyoung@redhat.com>
To:     Guilherme Piccoli <gpiccoli@canonical.com>
Cc:     Kairui Song <kasong@redhat.com>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, Baoquan He <bhe@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kexec mailing list <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Diego Elio =?iso-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
Message-ID: <20201123034705.GA5908@dhcp-128-65.nay.redhat.com>
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
 <CACPcB9e8p5Ayw15aOe5ZNPOa7MF3+pzPdcaZgTc_E_TZYkgD6Q@mail.gmail.com>
 <AC36B9BC-654C-4FC1-8EA3-94B986639F1E@oracle.com>
 <CACPcB9d7kU1TYaF-g2GH16Wg=hrQu71sGDoC8uMFFMc6oW_duQ@mail.gmail.com>
 <CAHD1Q_yB1B4gu7EDqbZJ5dxAAkr-dVKa9yRDK-tE3oLeTTmLJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHD1Q_yB1B4gu7EDqbZJ5dxAAkr-dVKa9yRDK-tE3oLeTTmLJQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guilherme,
On 11/22/20 at 12:32pm, Guilherme Piccoli wrote:
> Hi Dave and Kairui, thanks for your responses! OK, if that makes sense
> to you I'm fine with it. I'd just recommend to test recent kernels in
> multiple distros with the minimum "range" to see if 64M is enough for
> crashkernel, maybe we'd need to bump that.

Giving the different kernel configs and the different userspace
initramfs setup it is hard to get an uniform value for all distributions,
but we can have an interface/kconfig-option for them to provide a value like this patch
is doing. And it could be improved like Kairui said about some known
kernel added extra values later, probably some more improvements if
doable.

Thanks
Dave

