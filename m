Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B1E4595D0
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 20:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhKVT5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 14:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbhKVT5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 14:57:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85DEC061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 11:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KdZmRcc3t+prr1s7+hSrGjqXoixJomYlrH7C4x4Wvhk=; b=HC/R7sKScVNcLXHvCwjx2WD97d
        JWsW/Co+TC7xT7JyHfLebl4AMhkemUz2OnbnTTCmwI8kqKh5R81C6guICkw+NZBSp6DYNbBt4pN0Z
        ImwT8MxDNiiD+FMA1cDNJtssA4gyZnJ+kDx+FQ5+qcnE1kU3/F6INSjaDSbjgBLYIENA7tCvZ5ASq
        VtKVT442vmTKA7x2NYAknc3SxtCnD3La5RIBSACdC6KZh8PV9TXiHiM3emH7FJZcr21KoOmRPfNep
        qjbDwamRhY3jS2dY+Rxzmmk0bYEpOPQQHuwIKSujt5OQRV+1Lz2HBu+VKHKwrXm9GvvF0KHa/1g2I
        CLjY0r7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55800)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpFNs-00074Z-O1; Mon, 22 Nov 2021 19:53:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpFNo-0007xa-7a; Mon, 22 Nov 2021 19:53:44 +0000
Date:   Mon, 22 Nov 2021 19:53:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jordan Vrtanoski <jordan.vrtanoski@gmail.com>,
        stable@vger.kernel.org
Cc:     mw@semihalf.com, linux-arm-kernel@lists.infradead.org,
        stefanc@marvell.com
Subject: Re: ClearFog GT 8K not initialising SFP-H10GB-CU1M transceiver on
 5.4.150
Message-ID: <YZv1SBrYTXmorcLJ@shell.armlinux.org.uk>
References: <3AB36F18-250C-46F5-8135-94C79102B8A5@gmail.com>
 <YZONJC7KhACsq+5m@shell.armlinux.org.uk>
 <A2513E97-0C96-4E16-A9D2-98BB90490229@gmail.com>
 <YZlPeoRLSJKNJZ5F@shell.armlinux.org.uk>
 <256509AE-EE75-40AF-882F-F84A55F98C2D@gmail.com>
 <2F6C75BF-6CD8-4A58-B8AA-4D3A6B5A1008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2F6C75BF-6CD8-4A58-B8AA-4D3A6B5A1008@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 02:51:36PM +0400, Jordan Vrtanoski wrote:
> Hi,
>     After bisecting, the regression defect was introduced in 5.4.90 with the following patch:
> "[PATCH net v3] net: mvpp2: disable force link UP during port init procedure”
> 
>     The patch is changing the configuration of the port during the initialisation of MVPP22_XLG_CTRL0_REG, which
> on ClearFog GT 8K is preventing the MVPP2 to properly start the MAC after the transceiver is detected. After reverting 
> the patch, the transceiver works properly.

Right, the problem will be 875082244853 ("net: mvpp2: disable force
link UP during port init procedure") that has been backported to
kernels that it shouldn't have been applied to.

There is a subtle interaction between that commit and development work
leading up to it that wasn't obvious during the review. Specifically,
any kernel without fefeae73ac7a ("net: mvpp2: ensure the port is forced
down while changing modes") will now be broken.

However, fefeae73ac7a is development work, and so can't be backported.

Adding stable to this thread so they're aware of the issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
