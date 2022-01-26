Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0248449CB5C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbiAZNwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:52:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32884 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbiAZNwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:52:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73D4CB80AAD;
        Wed, 26 Jan 2022 13:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE873C340E3;
        Wed, 26 Jan 2022 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643205138;
        bh=uSJ0ZOYPJyZVA9tbsTEE513frvV72L1M7icrS+I9sCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUnY4yyhJOcYsw/W5FB8+xAOimFoR4ygkcucYYqX49TyQUAHBvSUPzjuoiXk+LHt+
         gBUc3ZdfFA1Ex40FmjJP8sGfgHuIgAIzFeLr6N0r/YKD7InsK/DkDuV12rH8hyWj/G
         B+YL6RMbt2a3de9S8nFQtuIdQe7LZ4t2j2WB0whY=
Date:   Wed, 26 Jan 2022 14:52:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     daniel.starke@siemens.com
Cc:     linux-serial@vger.kernel.org, jirislaby@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] tty: n_gsm: fix SW flow control encoding/handling
Message-ID: <YfFSD8WZiXs3yMmo@kroah.com>
References: <20220120101857.2509-1-daniel.starke@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120101857.2509-1-daniel.starke@siemens.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 02:18:57AM -0800, daniel.starke@siemens.com wrote:
> n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
> See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
> The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
> the newer 27.010 here. Chapter 5.2.7.3 states that DC1 (XON) and DC3 (XOFF)
> are the control characters defined in ISO/IEC 646. These shall be quoted if
> seen in the data stream to avoid interpretation as flow control characters.
> 
> ISO/IEC 646 refers to the set of ISO standards described as the ISO
> 7-bit coded character set for information interchange. Its final version
> is also known as ITU T.50.
> See https://www.itu.int/rec/T-REC-T.50-199209-I/en
> 
> To abide the standard it is needed to quote DC1 and DC3 correctly if these
> are seen as data bytes and not as control characters. The current
> implementation already tries to enforce this but fails to catch all
> defined cases. 3GPP 27.010 chapter 5.2.7.3 clearly states that the most
> significant bit shall be ignored for DC1 and DC3 handling. The current
> implementation handles only the case with the most significant bit set 0.
> Cases in which DC1 and DC3 have the most significant bit set 1 are left
> unhandled.
> 
> This patch fixes this by masking the data bytes with ISO_IEC_646_MASK (only
> the 7 least significant bits set 1) before comparing them with XON
> (a.k.a. DC1) and XOFF (a.k.a. DC3) when testing which byte values need
> quotation via byte stuffing.
> 
> Fixes: e1eaea46bb40 (tty: n_gsm line discipline, 2010-03-26)

Nit, no need for a date here, our tools get mad about stuff like this.
Look at the proper format for "Fixes:" line in the documentation.

thanks,

greg k-h
