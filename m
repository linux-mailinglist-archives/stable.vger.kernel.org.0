Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1429A76E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 10:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895452AbgJ0JLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 05:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895450AbgJ0JLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 05:11:18 -0400
Received: from saruman (88-113-213-94.elisa-laajakaista.fi [88.113.213.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E405B20747;
        Tue, 27 Oct 2020 09:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603789878;
        bh=3nJVYPqAmda6ppGiGO4U2OH69glESivKp8oHSZq5RgQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BQQ5PYMeAAZOQBfDzfWSSSm1iXaA0ftEvw9m0C3jTA4gElvkiXn39YZX/bhjF0quH
         F8A9lQk6EBD+k5bHnuv8kBDYkPJoWDICDEbEwAxF6jPMN4+5hkvm+emddAXor9FlpA
         ENOszDhRCQ+zbSYHIVDp8iHX5LQ9Ybsdb7Vwek38=
From:   Felipe Balbi <balbi@kernel.org>
To:     Peter Chen <peter.chen@nxp.com>, pawell@cadence.com, rogerq@ti.com
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com,
        gregkh@linuxfoundation.org, jun.li@nxp.com, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>
Subject: Re: [PATCH 3/3] usb: cdns3: Fix on-chip memory overflow issue
In-Reply-To: <20201016101659.29482-4-peter.chen@nxp.com>
References: <20201016101659.29482-1-peter.chen@nxp.com>
 <20201016101659.29482-4-peter.chen@nxp.com>
Date:   Tue, 27 Oct 2020 11:11:13 +0200
Message-ID: <87sga0c9u6.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Peter Chen <peter.chen@nxp.com> writes:
> From: Pawel Laszczak <pawell@cadence.com>
>
> Patch fixes issue caused setting On-chip memory overflow bit in usb_sts
> register. The issue occurred because EP_CFG register was set twice
> before USB_STS.CFGSTS was set. Every write operation on EP_CFG.BUFFERING
> causes that controller increases internal counter holding the number
> of reserved on-chip buffers. First time this register was updated in
> function cdns3_ep_config before delegating SET_CONFIGURATION request
> to class driver and again it was updated when class wanted to enable
> endpoint.  This patch fixes this issue by configuring endpoints
> enabled by class driver in cdns3_gadget_ep_enable and others just
> before status stage.
>
> Cc: <stable@vger.kernel.org> #v5.8+
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Reported-and-tested-by: Peter Chen <peter.chen@nxp.com>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>

This looks very large for a fix, are you sure there isn't a minimal fix
hidden somewhere?

-- 
balbi
