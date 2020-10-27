Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A329C4BB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758616AbgJ0R5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:57:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57403 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2901230AbgJ0OVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 10:21:24 -0400
Received: (qmail 1234573 invoked by uid 1000); 27 Oct 2020 10:21:23 -0400
Date:   Tue, 27 Oct 2020 10:21:23 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Peter Chen <peter.chen@nxp.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        "pawell@cadence.com" <pawell@cadence.com>,
        "rogerq@ti.com" <rogerq@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jun Li <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign
 extension
Message-ID: <20201027142123.GA1233346@rowland.harvard.edu>
References: <20201016101659.29482-1-peter.chen@nxp.com>
 <20201016101659.29482-2-peter.chen@nxp.com>
 <871rhkdori.fsf@kernel.org>
 <20201027094825.GA5940@b29397-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027094825.GA5940@b29397-desktop>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 09:48:54AM +0000, Peter Chen wrote:
> If you compile the code:
> 
> unsigned int k = 0x80 << 24 + 0x81;
> 
> It will report build warning:
> warning: left shift count >= width of type [-Wshift-count-overflow]

That's a separate issue.  I believe (but haven't checked) that the << 
operator has lower precedence than +, so the compiler interprets the 
expression as:

unsigned int k = 0x80 << (24 + 0x81);

and it's pretty obvious why this causes an error.  Instead, try 
compiling:

unsigned int k = (0x80 << 24) + 0x81;

You may get an error message about signed-integer overflow, but not 
about shift-count overflow.

Alan Stern
