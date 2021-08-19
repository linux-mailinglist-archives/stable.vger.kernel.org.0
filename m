Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FF83F12DB
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 07:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhHSFpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 01:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229906AbhHSFpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 01:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345D76101A;
        Thu, 19 Aug 2021 05:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629351880;
        bh=hKWo3UjRTpYmk1R9ajNcB08DadbLBuG4PaW5uaGd27E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1KATiH/ZHa5bGpamJwuJ3a3M9N1Zr9vifzkG/YbEmmty8SV9jDx9Wxb8aKem2W41a
         c5LrVFzdjQicMtiFUNTJEeu+odxDHK9ZY/sMnKh+H43gHCxApIjCEdg2gz2wffh5j0
         kuTExKt7TFkgX7/T0BZtSKqJj65Rb1pVSgHnBX3o=
Date:   Thu, 19 Aug 2021 07:44:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike <mpagano@gentoo.org>
Cc:     stable@vger.kernel.org, pav@iki.fi
Subject: Re: Bluetooth: btusb: check conditions before enabling USB ALT 3 for
 WBS
Message-ID: <YR3vxtQuhyPG/SHW@kroah.com>
References: <a680e819-74da-0c40-9812-9f4e748dc20b@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a680e819-74da-0c40-9812-9f4e748dc20b@gentoo.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 07:04:47PM -0400, Mike wrote:
> From: Pauli Virtanen <pav@iki.fi>
> Kernel Version 5.13
> 
> commit 55981d3541812234e687062926ff199c83f79a39 upstream.

There is no such commit in Linus's tree :(


> - new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
> - /* Because mSBC frames do not need to be aligned to the
> - * SCO packet boundary. If support the Alt 3, use the
> - * Alt 3 for HCI payload >= 60 Bytes let air packet
> - * data satisfy 60 bytes.
> - */
> - if (new_alts == 1 && btusb_find_altsetting(data, 3))
> + if (btusb_find_altsetting(data, 6))
> + new_alts = 6;
> + else if (btusb_find_altsetting(data, 3) &&
> + hdev->sco_mtu >= 72 &&
> + test_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags))
> new_alts = 3;


Your patch is also corrupted and could not be applied :(

