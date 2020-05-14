Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD791D24C3
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 03:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgENBe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 21:34:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48913 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725977AbgENBe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 21:34:26 -0400
Received: (qmail 11256 invoked by uid 500); 13 May 2020 21:34:25 -0400
Date:   Wed, 13 May 2020 21:34:25 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Peter Chen <peter.chen@nxp.com>
Cc:     Jun Li <jun.li@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Manu Gautam <mgautam@codeaurora.org>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggMS8x?= =?utf-8?Q?=5D?= usb: host:
 xhci-plat: keep runtime active when remove host
Message-ID: <20200514013425.GB10515@rowland.harvard.edu>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
 <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>
 <62e24805-5c80-f6b4-b8ba-cb6d649a878b@linux.intel.com>
 <VE1PR04MB6528D2A1C08ED9F091BCF3FD89BF0@VE1PR04MB6528.eurprd04.prod.outlook.com>
 <20200514013221.GA20346@b29397-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200514013221.GA20346@b29397-desktop>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 01:31:59AM +0000, Peter Chen wrote:
> On 20-05-13 14:45:42, Jun Li wrote:
> > ​
> > ...
> > > Would it make sense to change xhci_plat_remove() to
> > 
> > 
> > 
> > > xhci_plat_remove()
> > 
> > >   pm_runtime_disable()
> > 
> > >   <remove and put both hcd's>
> > 
> > >   pm_runtime_set_suspended()
> > 
> > 
> > 
> > > or possibly wrapping the remove in a runtime get/put:
> > 
> > > xhci_plat_remove()
> > 
> > >  pm_runtime_get_noresume()
> > 
> > >   pm_runtime_disable()
> > 
> >  >  <remove and put both hcd's>
> > 
> >  >  pm_runtime_set_suspended()
> > 
> >  >  pm_runtime_put_noidle()
> > 
> > I think it's better to keep runtime active during driver removal,
> > how about this:
> > 
> > pm_runtime_get_sync()
> > <remove and put both hcd's>
> > pm_runtime_disable()
> > pm_runtime_put_noidle()
> > pm_runtime_set_suspended()
> > 
> 
> I think it is more reasonable since for some DRD controllers if
> DRD core is suspended, access the xHCI register (eg, we remove
> xhci-plat-hcd module at the time) may hang the system. Alan &
> Mathias, what's your opinion?

Jun's suggestion looks good to me.

Alan Stern
