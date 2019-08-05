Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42E7825FC
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 22:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbfHEUU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 16:20:28 -0400
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49968 "EHLO
        emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 16:20:27 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2019 16:20:26 EDT
Received: from toshiba (85-76-131-212-nat.elisa-mobile.fi [85.76.131.212])
        by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 8249C30071;
        Mon,  5 Aug 2019 23:11:09 +0300 (EEST)
Message-ID: <5D488D55.B84FC098@users.sourceforge.net>
Date:   Mon, 05 Aug 2019 23:11:01 +0300
From:   Jari Ruusu <jariruusu@users.sourceforge.net>
MIME-Version: 1.0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.188-stable review
References: <20190805124924.788666484@linuxfoundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.188 release.

Peter Zijlstra's "x86/atomic: Fix smp_mb__{before,after}_atomic()"
upstream commit 69d927bba39517d0980462efc051875b7f4db185 seems to
be missing/lost from 4.9 and older stable kernels.

That patch has 10 hunks, first one of those does not apply cleanly to
4.9 kernel because it attempts to modify Documentation/atomic_t.txt
file which does not exist in older kernels. Other 9 hunks apply with
small offsets and fuzz, but modifications find their correct places anyway.
Those other 9 hunks are the important ones, first hunk can be ignored.

Greg,
Please take Peter Zijlstra's original patch and "force" apply it like this
to 4.9 kernels:

  patch -p1 -f <ORIGINAL.patch

and for 4.4 kernels like this:

  cat ORIGINAL.patch | sed -e 's/__smp_mb__/smp_mb__/' | patch -p1 -f -l

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
