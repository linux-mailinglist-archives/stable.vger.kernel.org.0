Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F339D10C8E1
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 13:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfK1Mqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 07:46:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52429 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfK1Mqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 07:46:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id l1so10837659wme.2
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 04:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=STsXGIxlpKeuPZp+Vn2QA8KnIL8lpW4s4OgT+hmouXE=;
        b=NfCy8kNCntgaDCtGBuCJGqwrGwE+TjPAz9SDCI05cYUfodniq4uCbybMqgQOvztEkC
         IBB0BP+nOnmXCC/6rkzp4g84+fSn3NiRA/9FKoFP2s///Vz0yTNHZFbVBNHtZEbF7t/c
         lFzhJwD51zhewk12JnlAHj6wFWpL/gn43DJEN3946Bl6yE1236p26yavF3gKSIuk8QC1
         sXC44EadYZeHFasnF6dYifpwqPZ7R6M5iqE/NQ06ymjY1rCvqkyVvYApRLjWqzFNngYT
         9bMipcpnhdE4WHGYmVKtvHA9ncyG2RzFjoFF2s9d3tABI4x4X1UakpPHa6QXvw/GCQS5
         +KcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=STsXGIxlpKeuPZp+Vn2QA8KnIL8lpW4s4OgT+hmouXE=;
        b=GkhJj2ToYKQDkDy2Q3piF8/8TQh86OmCbrtEBp4DuKWOPr55B6AKS4I520f46Ewl1T
         1pdIICjk3hFZN1KH636p5Uo15OXQMglzyegQAr/8cXtNimCplDWF4TN9L3iAR/r4zXx5
         fqZte8c7Y1IYzO4S6UqrDq4T10k5DGjr5foFehmwCL90WYnHrOVy0Hy1i2D7bWpjoxzt
         QZaxIEPLLdRz1PktxHjx4ACNo2OHk36SBEq8fjkIOIqruAsl0oXSl/WtZ+KyoYtx8Z8M
         T/QVSXoOsU2ZkbIPiBNWUvWcKjSYJFQrccv4SudG4kExx3wx63jCikArMDN9QZZWtRz8
         +NIw==
X-Gm-Message-State: APjAAAXdSJq8bkj3CTjP/jLLnWiCtoevQCoIZF8M9g9sdPk1ETDKGRu/
        tUPGPYSKBMAOBLuVazMXEIIIauU4
X-Google-Smtp-Source: APXvYqz1W8bxVosL7NtHYjDlEnoHqf0gsbzp+DXZgse8WI5qd4Ou2QMkjPFXu86KVVEcRCv9aWJFeQ==
X-Received: by 2002:a7b:c8c2:: with SMTP id f2mr8904741wml.99.1574945206599;
        Thu, 28 Nov 2019 04:46:46 -0800 (PST)
Received: from arch-x1c3 ([2a00:5f00:102:0:9665:9cff:feee:aa4d])
        by smtp.gmail.com with ESMTPSA id f19sm24492776wrf.23.2019.11.28.04.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 04:46:45 -0800 (PST)
Date:   Thu, 28 Nov 2019 12:46:03 +0000
From:   Emil Velikov <emil.l.velikov@gmail.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     john.p.donnelly@oracle.com, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?iso-8859-1?Q?Jos=E9?= Roberto de Souza 
        <jose.souza@intel.com>, Dave Airlie <airlied@redhat.com>,
        "# 3.13+" <stable@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v2 1/3] drm/mgag200: Extract device type from flags
Message-ID: <20191128124603.GA9293@arch-x1c3>
References: <20191126101529.20356-1-tzimmermann@suse.de>
 <20191126101529.20356-2-tzimmermann@suse.de>
 <CACvgo52_L9RRCh6rKBCqkCuBwmH40NPnGQkCtqpR-T1feKC_5w@mail.gmail.com>
 <98068118-8988-e31a-11c3-17a88059fbed@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98068118-8988-e31a-11c3-17a88059fbed@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/11/27, Thomas Zimmermann wrote:
> Hi Emil
> 
> Am 27.11.19 um 17:29 schrieb Emil Velikov:
> > Hi Thomas,
> > 
> > On Tue, 26 Nov 2019 at 10:15, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >>
> >> Adds a conversion function that extracts the device type from the
> >> PCI id-table flags. Allows for storing additional information in the
> >> other flag bits.
> >>
> >> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> >> Fixes: 81da87f63a1e ("drm: Replace drm_gem_vram_push_to_system() with kunmap + unpin")
> > 
> > Are you sure the fixes tag is correct? Neither the commit summary nor
> > the patch itself seems related to the changes below.
> 
> Yes, it's correct. It's part of a patch series [1][2][3] that fixes the bug.
> 
> Best regards
> Thomas
> 
> [1]
> https://cgit.freedesktop.org/drm/drm-tip/commit/?id=3a8a5aba142a44eaeba0cb0ec1b4a8f177b5e59a
> [2]
> https://cgit.freedesktop.org/drm/drm-tip/commit/?id=d6d437d97d54c85a1a93967b2745e31dff03365a
> [3]
> https://cgit.freedesktop.org/drm/drm-tip/commit/?id=1591fadf857cdbaf2baa55e421af99a61354713c
> 
I see, different alignment is required for one mga200 GPU.
Personally, I would have mentioned that in the commit message.

Regardless, hats off for the prompt fixup.

Thanks
Emil
