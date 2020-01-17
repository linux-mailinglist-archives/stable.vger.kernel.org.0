Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8942C140D2F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 16:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgAQPC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 10:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgAQPC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 10:02:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D2482083E;
        Fri, 17 Jan 2020 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579273345;
        bh=Ie8jxlqHf8n1AVZX7Q2iEHcV0/OZKqjJ18YlH5Tf0M0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SmmonUGlMg2HXwrgnxWjGXPEUdl5uAgIhGx6F2cPLOnxYLmdtDolQWUy6qMcQVURY
         It1yC5nOsdLXVB9iGq7KnnvRf1Zwi7m1EW29K24l76ONL5YOjg7xVARe+PydOOAGRv
         369+UCiNYmZ5xJs6wU4f9KsSXOC2qIH6RxMOsOG8=
Date:   Fri, 17 Jan 2020 16:02:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] USB: serial: quatech2: handle unbound ports
Message-ID: <20200117150223.GB1898895@kroah.com>
References: <20200117143526.5048-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117143526.5048-1-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 03:35:26PM +0100, Johan Hovold wrote:
> Check for NULL port data in the modem- and line-status handlers to avoid
> dereferencing a NULL pointer in the unlikely case where a port device
> isn't bound to a driver (e.g. after an allocation failure on port
> probe).
> 
> Note that the other (stubbed) event handlers qt2_process_xmit_empty()
> and qt2_process_flush() would need similar sanity checks in case they
> are ever implemented.
> 
> Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
> Cc: stable <stable@vger.kernel.org>     # 3.5
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> v2
>  - move sanity checks to where the actual dereferences take place
>  - drop sanity checks from the stubbed event handlers

Looks good, thanks for the rewrite:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
