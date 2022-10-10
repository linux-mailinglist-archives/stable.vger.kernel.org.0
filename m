Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770BA5F9A77
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJJHwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJJHwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:52:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0D8131;
        Mon, 10 Oct 2022 00:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665388350; x=1696924350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nKoNqwSE/vKT2owlDayb4xvZLmMsG+86Uz7TmrW4nH8=;
  b=eh/rgPhstPajUfBZruoiECeZaUY0hDoBQX0586Aab+ukIlzrIkVrRg0z
   0DqR0y4V9tBW/sRqkYZXaRNvHxjKIy0//8i0RBXL/YuBpnK45u0mmlDc7
   6T/Rb5R12j/31wYZ9H6oX6e1Lk62I9ssUg50eHtPDZTzfYn2FEMvVUH/m
   KXU4SXFuRZOMyhdLr0nbPNZBVMX5OHubIZBSPDsvZs7CrpybWtCVOcger
   fiA9Bq9no/JZlp83l8JgBlU7hh0DFe2jCI4gRN9CbKTJ09ABp29zoJlZC
   bT2550YWqd7W4XnlaapF6lKkbBmR+Gm6QLODcq3+DT2y7QhKCEioAtVct
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="287405065"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="287405065"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 00:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="768299794"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="768299794"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 10 Oct 2022 00:52:25 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 10 Oct 2022 10:52:24 +0300
Date:   Mon, 10 Oct 2022 10:52:24 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bastian Rieck <bastian@rieck.me>, grzegorz.alibozek@gmail.com,
        andrew.co@free.fr, meven29@gmail.com, pchernik@gmail.com,
        jorge.cep.mart@gmail.com, danielmorgan@disroot.org,
        bernie@codewiz.org, saipavanchitta1998@gmail.com,
        rubin@starset.net, maniette@gmail.com, nate@kde.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 0/2] usb: typec: UCSI resume fix
Message-ID: <Y0PPOBFFuWzFj0Oy@kuha.fi.intel.com>
References: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
 <Y0A6Pb5owOWVVQET@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0A6Pb5owOWVVQET@kroah.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 07, 2022 at 04:39:57PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Oct 07, 2022 at 01:09:49PM +0300, Heikki Krogerus wrote:
> > Hi Greg,
> > 
> > These two patches fix an issue where the ucsi drivers fail to detect
> > changes on the connection status (connections/disconnections) that
> > happen while the system is suspended.
> > 
> > 
> > Heikki Krogerus (2):
> >   usb: typec: ucsi: Check the connection on resume
> >   usb: typec: ucsi: acpi: Implement resume callback
> > 
> >  drivers/usb/typec/ucsi/ucsi.c      | 42 +++++++++++++++++++++---------
> >  drivers/usb/typec/ucsi/ucsi_acpi.c | 10 +++++++
> >  2 files changed, 39 insertions(+), 13 deletions(-)
> 
> These are ok to go in after -rc1, right?

Yes, I think so.

thanks,

-- 
heikki
