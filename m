Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA08F1FD2E6
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 18:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgFQQxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 12:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 12:53:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11BEB20897;
        Wed, 17 Jun 2020 16:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592412814;
        bh=BeaXBdaarZVLXWFzDTXzvJ/Qb8JF+BXuA1Ss3tfBBvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dB2CoxrjtiI9CKWgdcKuO0er4duvCEbBVyDsLWAY8jsXORKDJnEBEOv4ozAPaV+5v
         08Xruf9sUygmbd6JUEY5CCvi4/USHX+V6/AhoFo4Ft63HD+HBE8lk0Dv7KpfB8DupV
         7TUNKbcXbepE6aZ4htZThyvpXTqh6beKzC7DXzo0=
Date:   Wed, 17 Jun 2020 18:53:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ardb@kernel.org, rafael.j.wysocki@intel.com
Subject: Re: [PATCH 5.4 064/134] ACPI: GED: add support for _Exx / _Lxx
 handler methods
Message-ID: <20200617165327.GD3794995@kroah.com>
References: <20200616153100.633279950@linuxfoundation.org>
 <20200616153103.838898964@linuxfoundation.org>
 <OSBPR01MB29835381F4879AF2614194F3929A0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
 <OSBPR01MB2983F4C32B052F1438964A93929A0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <OSBPR01MB2983F4C32B052F1438964A93929A0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 09:26:41AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi again,
> 
> > -----Original Message-----
> > From: iwamatsu nobuhiro(岩松 信洋 □ＳＷＣ◯ＡＣＴ)
> > Sent: Wednesday, June 17, 2020 6:23 PM
> > To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org; Ard Biesheuvel <ardb@kernel.org>; Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: RE: [PATCH 5.4 064/134] ACPI: GED: add support for _Exx / _Lxx handler methods
> > 
> > Hi,
> > 
> > > -----Original Message-----
> > > From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.org] On Behalf Of Greg Kroah-Hartman
> > > Sent: Wednesday, June 17, 2020 12:34 AM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kernel.org; Ard Biesheuvel <ardb@kernel.org>;
> > Rafael
> > > J. Wysocki <rafael.j.wysocki@intel.com>
> > > Subject: [PATCH 5.4 064/134] ACPI: GED: add support for _Exx / _Lxx handler methods
> > >
> > > From: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > commit ea6f3af4c5e63f6981c0b0ab8ebec438e2d5ef40 upstream.
> > >
> > > Per the ACPI spec, interrupts in the range [0, 255] may be handled
> > > in AML using individual methods whose naming is based on the format
> > > _Exx or _Lxx, where xx is the hex representation of the interrupt
> > > index.
> > >
> > > Add support for this missing feature to our ACPI GED driver.
> > >
> > > Cc: v4.9+ <stable@vger.kernel.org> # v4.9+
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > 
> > This patch also requires the following patch.
> > Please apply to this kernel version, 4.9, 4.14, 4.19, 5.6 and 5.7.
> > 
> > From e5c399b0bd6490c12c0af2a9eaa9d7cd805d52c9 Mon Sep 17 00:00:00 2001
> > From: Ard Biesheuvel <ardb@kernel.org>
> > Date: Wed, 27 May 2020 13:37:00 +0200
> 
> I update with the correct information.
> 
> commit e5c399b0bd6490c12c0af2a9eaa9d7cd805d52c9
> Author: Ard Biesheuvel <ardb@kernel.org>
> Date:   Wed May 27 13:37:00 2020 +0200
> 
> ....

Now queued up, thanks!

greg k-h
