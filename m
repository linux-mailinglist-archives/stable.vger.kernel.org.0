Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397E140FAF0
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbhIQO7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 10:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234100AbhIQO7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 10:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F6F61152;
        Fri, 17 Sep 2021 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631890690;
        bh=k1/hzmBDrLSXqe7cEz4TFzwO14MoXt+0q1h/d+eWqz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=moTC0OM5szfHIDBQSV8uet4K65UTTOzT8vvZIHCtG+nIYkUgqtYPKm3lS9A6YoDj5
         J/nIgQAgzjwFCBg4tsCTRG3vWfWgdBixmI620/6XGm6aMc9L+NCbOjml7uo0+be5uS
         i3+EuTrj6afkEYzpq8b92ZvFXlEA3rGViJrUiBcHyerg6AvN+RqnCLX4dkiqiH5Ta+
         kYYnDfq6Vae+gFHxfxBwzc18eeZxXjnrWecEIZKGSFBD+RZmAuHHF2/SBM9ctx3FX5
         P8JKXnI95Xd8Jvnjgxl6bbM9FnMA76UcXZyql1+IMapeyZ1k97dSa4B9K4mEy9k6v2
         E0hUfA9u1+EhQ==
Date:   Fri, 17 Sep 2021 07:58:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210917075809.3c89cb92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917140003.GA1520823@rocinante>
References: <20210916131739.1260552-1-kuba@kernel.org>
        <20210917140003.GA1520823@rocinante>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Sep 2021 16:00:03 +0200 Krzysztof Wilczy=C5=84ski wrote:
> > The Intel documentation does not list my device [1], but
> > linuxhw [2] does, and it seems to list a few more bridges
> > we do not currently cover (3e31, 3ecc, 3e35, 3e0f). =20
>=20
> This might be out-of-scope for this particular patch, but it makes me
> wonder - if we know that these other bridges were identified as having the
> same issue, would it be prudent to add a quriks for them too?  It might
> save some people a headache and such.

Indeed, I was about to do it but the disagreement between the Intel
docs and the linuxhw device list discouraged me. It's confusing that
the most popular SKU in the field (according to linuxhw, which is also
the one I have and the one addressed by this patch) is not in the
official Intel PDF. And what about the numbers that fall in between
the known revisions? Perhaps we could use a mask instead of having
10+ entries?

Then there's also a precedent of adding them one by one in the patches
quoted my Bjorn.

All in all I thought I'd just mention this and let the people familiar
with x86 platforms guide me.

Or maybe we can wait for patches from Paul or Peter to fix the less
popular devices?

Not sure.. I'm happy to produce a patch that adds more entries, or=20
for someone else to do it..
