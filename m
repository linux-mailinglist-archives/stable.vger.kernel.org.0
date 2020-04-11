Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108B11A4F92
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgDKLlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 07:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgDKLlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 07:41:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F160020673;
        Sat, 11 Apr 2020 11:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586605299;
        bh=7Xgm9xSwBs283LmTMtfx7PeoquvCMwsBjOqqJE2OhAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZphxNtwtIcZ+2BwVMmVd3L1cMSfHw51mAWJaBPVB15BiITGBY62GIyLpay7gMqjvv
         DdbVWLs+pIPbL0GET+B4xkhATdjHA2qW6g2HxvlEAfgt9kZVWWL8NNPXRZ8C0djvX6
         zJgRHzd+bFTHz5OHBgUfZ/hBLdiTLU/w4adpwHuU=
Date:   Sat, 11 Apr 2020 13:41:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4.14.y] acpi/nfit: Fix bus command validation
Message-ID: <20200411114137.GD2606747@kroah.com>
References: <20200410152731.85430-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410152731.85430-1-linux@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 10, 2020 at 08:27:31AM -0700, Guenter Roeck wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> [ Upstream commit ebe9f6f19d80d8978d16078dff3d5bd93ad8d102 ]
> 
> Commit 11189c1089da "acpi/nfit: Fix command-supported detection" broke
> ND_CMD_CALL for bus-level commands. The "func = cmd" assumption is only
> valid for:
> 
>     ND_CMD_ARS_CAP
>     ND_CMD_ARS_START
>     ND_CMD_ARS_STATUS
>     ND_CMD_CLEAR_ERROR
> 
> The function number otherwise needs to be pulled from the command
> payload for:
> 
>     NFIT_CMD_TRANSLATE_SPA
>     NFIT_CMD_ARS_INJECT_SET
>     NFIT_CMD_ARS_INJECT_CLEAR
>     NFIT_CMD_ARS_INJECT_GET
> 
> Update cmd_to_func() for the bus case and call it in the common path.
> 
> Fixes: 11189c1089da ("acpi/nfit: Fix command-supported detection")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> Reported-by: Grzegorz Burzynski <grzegorz.burzynski@intel.com>
> Tested-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> [groeck: backport to v4.14.y: adjust for missing commit 4b27db7e26cdb]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Commit 11189c1089da ("acpi/nfit: Fix command-supported detection")
> has been applied to v4.14.y as commit 1c285c34a509, but not its fix.
> 
> This patch has already been applied to v4.19.y. v5.4.y and later are
> not affected.
> 
>  drivers/acpi/nfit/core.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)

Now queued up, thanks.

greg k-h
