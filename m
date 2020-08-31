Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B8B2573EA
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 08:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgHaGpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 02:45:03 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46828 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgHaGpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 02:45:02 -0400
Received: by mail-lj1-f195.google.com with SMTP id h19so5311406ljg.13;
        Sun, 30 Aug 2020 23:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xRYa6WvfqJz3WHv3sEhdsCUyjG/CtRbsaAhiwDu8HgQ=;
        b=Rs5m2OfjtFKmTsq+MGyXAa8gXQ4Df3TADYYbkPpapjx0gureguv9iSZ+AivbyEH6v6
         EKtizd6h2GdHE3pClQLXd5zFAHwsKelclEEPIFe5fwrTSbnQ7NKnTV861jgEmaCaXYWq
         DAjMMuatJk+jZytmkQCOBMBBX05BSQPtnG9eulBp7jJF8hThH1X9y6hcv0IESESTgfyT
         3sPzVsuRkUHm2WkPbVOSWqQkq3gn9dfnXeViLi34i+NF+8tsSjmWfvoakf7Q1D1S1v6P
         jTYap05GDA4aauzzbG9U4Nr/qJt73/LCZGn1mazd7Wb2dvsRBiMWbulIxCpEJDjLhh1D
         /qhA==
X-Gm-Message-State: AOAM533MpV0wi2xxdidsBJQjD5TGpLxalaYCnJwtbXbhELRsz4s0dA/F
        C9tB52IDeGkbD7qC9Db4Utg=
X-Google-Smtp-Source: ABdhPJzoWnc64lR5hzkIJ8/VwFhBxhpPzBCOFC73f09BfIDx8noZz4Rr2UuontmpPPfUtNBp2TeCrg==
X-Received: by 2002:a2e:4942:: with SMTP id b2mr616100ljd.382.1598856299971;
        Sun, 30 Aug 2020 23:44:59 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id y4sm621054ljk.61.2020.08.30.23.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 23:44:59 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kCdYi-0007jW-0v; Mon, 31 Aug 2020 08:44:52 +0200
Date:   Mon, 31 Aug 2020 08:44:52 +0200
From:   Johan Hovold <johan@kernel.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        AceLan Kao <acelan.kao@canonical.com>,
        Sebastian Sjoholm <ssjoholm@mac.com>,
        Dan Williams <dcbw@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: support dynamic Quectel USB
 compositions
Message-ID: <20200831064452.GO21288@localhost>
References: <20200829134250.59118-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200829134250.59118-1-bjorn@mork.no>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 29, 2020 at 03:42:50PM +0200, Bjørn Mork wrote:
> The USB composition, defining the set of exported functions, is dynamic
> in newer Quectel modems.  Default functions can be disabled and
> alternative functions can be enabled instead.  The alternatives
> includes class functions using interface pairs, which should be
> handled by the respective class drivers.
> 
> Active interfaces are numbered consecutively, so static
> blacklisting based on interface numbers will fail when the
> composition changes.  An example of such an error, where the
> option driver has bound to the CDC ECM data interface,
> preventing cdc_ether from handling this function:
> 
>  T: Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 2 Spd=480 MxCh= 0
>  D: Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs= 1
>  P: Vendor=2c7c ProdID=0125 Rev= 3.18
>  S: Manufacturer=Quectel
>  S: Product=EC25-AF
>  C:* #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
>  A: FirstIf#= 4 IfCount= 2 Cls=02(comm.) Sub=06 Prot=00
>  I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
>  E: Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>  E: Ad=83(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
>  E: Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>  E: Ad=85(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
>  E: Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>  E: Ad=87(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
>  E: Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 4 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=06 Prot=00 Driver=(none)
>  E: Ad=89(I) Atr=03(Int.) MxPS= 16 Ivl=32ms
>  I:* If#= 5 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=00 Driver=option
>  I: If#= 5 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=option
>  E: Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> Another device with the same id gets correct drivers, since the
> interface of the network function happens to be blacklisted by option:
> 
>  T: Bus=01 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#= 3 Spd=480 MxCh= 0
>  D: Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs= 1
>  P: Vendor=2c7c ProdID=0125 Rev= 3.18
>  S: Manufacturer=Android
>  S: Product=Android
>  C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
>  I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
>  E: Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>  E: Ad=83(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
>  E: Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>  E: Ad=85(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
>  E: Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>  E: Ad=87(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
>  E: Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
>  E: Ad=89(I) Atr=03(Int.) MxPS= 8 Ivl=32ms
>  E: Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>  E: Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> Change rules for EC21, EC25, BG96 and EG95 to match vendor specific
> serial functions only, to prevent binding to class functions. Require
> 2 endpoints on ff/ff/ff functions, avoiding the 3 endpoint QMI/RMNET
> network functions.
> 
> Cc: AceLan Kao <acelan.kao@canonical.com>
> Cc: Sebastian Sjoholm <ssjoholm@mac.com>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Thanks, Bjørn. Now applied.

Johan
