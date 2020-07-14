Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D2E21F24A
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 15:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgGNNRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 09:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgGNNRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 09:17:43 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F95E22203;
        Tue, 14 Jul 2020 13:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594732663;
        bh=AYUTme/0NKI8o/8pYHxaWMD/z47b+ayOmouJUcj+GVI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=a6xFUfrZ71TQzOZrLO+XjCUFwb34IzEV7AAwHajseJzUS5RTxVPxWp9Ep0iBHppqd
         CmkW3M2hub/Wpy+nV8GVKLfCBNIARoQietzr++A+tZ7rIbOrhhrgV+jyTQrLrcB1fx
         qUIq36ao8TJfHdKOeW2C24vW4gktsJRCuJ5FEYl4=
Date:   Tue, 14 Jul 2020 15:17:39 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Darren Hart <dvhart@infradead.org>
cc:     Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Grant Likely <grant.likely@arm.com>,
        Darren Hart <darren@dvhart.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] hid-input: Fix devices that return multiple bytes in
 battery report
In-Reply-To: <CAJuF2pzvh2G7_2q88a4e=dpB1RATrdF8jsOkpVuuueZLGGbsiQ@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.2007141517280.23768@cbobk.fhfr.pm>
References: <20200710151939.4894-1-grant.likely@arm.com> <CAJuF2pzvh2G7_2q88a4e=dpB1RATrdF8jsOkpVuuueZLGGbsiQ@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Jul 2020, Darren Hart wrote:

> > Some devices, particularly the 3DConnexion Spacemouse wireless 3D
> > controllers, return more than just the battery capacity in the battery
> > report. The Spacemouse devices return an additional byte with a device
> > specific field. However, hidinput_query_battery_capacity() only
> > requests a 2 byte transfer.
> >
> > When a spacemouse is connected via USB (direct wire, no wireless dongle)
> > and it returns a 3 byte report instead of the assumed 2 byte battery
> > report the larger transfer confuses and frightens the USB subsystem
> > which chooses to ignore the transfer. Then after 2 seconds assume the
> > device has stopped responding and reset it. This can be reproduced
> > easily by using a wired connection with a wireless spacemouse. The
> > Spacemouse will enter a loop of resetting every 2 seconds which can be
> > observed in dmesg.
> >
> > This patch solves the problem by increasing the transfer request to 4
> > bytes instead of 2. The fix isn't particularly elegant, but it is simple
> > and safe to backport to stable kernels. A further patch will follow to
> > more elegantly handle battery reports that contain additional data.
> >
> 
> Applied and tested on 5.8.0-rc4+ (aa0c9086b40c) with a 3Dconnexion
> SpaceMouse Wireless (tested connected via USB). Observed the same
> behavior Grant reports before the patch. After the patch, the device stays
> connected successfully.
> 
> Tested-by: Darren Hart <dvhart@infradead.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

