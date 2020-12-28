Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2012E6A20
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgL1SzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgL1SzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:55:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC9F6221F8;
        Mon, 28 Dec 2020 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181665;
        bh=NWnEu5HaAGiZiFcDZvuHZGseyVq9ff5u4/mPVtDJ6fM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CAC3xZ6SWM5I7K7ey7IlppP2BHU56kZMHBGKAqFeCphiW5FX0Rep3t1VD216BhO99
         Q1jemfpEJz/7U5lTv583EQTHRmA9c5X1qtNPXDtQXDC/5IYZS/SSaZ9xBnZLjLWXur
         tVo6FBppZGHhFiJcEnUOZPGXiC6vAeyJL2indVUi1S3SL2ttaV4hadoIjQz3iHxS2g
         L2MmX3eVMyzVPI4BtBVzkYu+xHbQmLETwyxyVnelAs3KTt5og9du0BYvjcTV9PaVpt
         7j1IOZlrGRbzAq5NRgRi69acSG4Uf4FL2TcR1+XyCJuUDYm3VfHSSK+9HHYZhRET+y
         F2hhdwBumCaEQ==
Date:   Mon, 28 Dec 2020 10:54:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= 
        <bjorn.topel@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 462/717] ice, xsk: clear the status bits for the
 next_to_use descriptor
Message-ID: <20201228105423.46e77460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228125043.105740628@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
        <20201228125043.105740628@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 13:47:40 +0100 Greg Kroah-Hartman wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> [ Upstream commit 8d14768a7972b92c73259f0c9c45b969d85e3a60 ]
>=20
> On the Rx side, the next_to_use index points to the next item in the
> HW ring to be refilled/allocated, and next_to_clean points to the next
> item to potentially be processed.
>=20
> When the HW Rx ring is fully refilled, i.e. no packets has been
> processed, the next_to_use will be next_to_clean - 1. When the ring is
> fully processed next_to_clean will be equal to next_to_use. The latter
> case is where a bug is triggered.
>=20
> If the next_to_use bits are not cleared, and the "fully processed"
> state is entered, a stale descriptor can be processed.
>=20
> The skb-path correctly clear the status bit for the next_to_use
> descriptor, but the AF_XDP zero-copy path did not do that.
>=20
> This change adds the status bits clearing of the next_to_use
> descriptor.
>=20
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Oh wow, so much for Sasha waiting longer for code to get tested before
auto-pulling things into stable :/

I have this change and other changes here queued, but haven't sent the
submission yet.

How long is the auto-backporting delay in terms of calendar days?
