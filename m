Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2926D7FF
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 02:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfGSAy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 20:54:57 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45037 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfGSAy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 20:54:56 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so54851486iob.11;
        Thu, 18 Jul 2019 17:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nUnEs6T4yxPkW6WREIbs9wEKoNb3SkiM2LwRerDYtYk=;
        b=Zp+YsoOb4+YimJVFP+rmmehJ7QupMsunxLPRhTMQ7jXnoaHswwRA1ATocJLmEZGCVY
         dZ17PXS2HfTKZjCak2QKCM3/KtBhoIdhYkiY6ZFEGdN0TSOsFEB8NEWffhOLlN8DIUaP
         AQ+cySK3q/XQid4gwfTVHkupIG6TIW0UG/4NchdhoFk5HmOC4b0Qxm8gqd7KSn6+qSrz
         GI95Nl5k0smjnpB+/CnFURsbzqPPljIRcaz7TXyVjzsPGtLgeXT9C+4GuWUGrZ+0sJJJ
         wrQ5u3WIkZI1FRzkNTSbRSmSYAPIQyKqWygmLS2XiKrdNf47MvFkG3/EGWveYPkmg7JK
         O1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nUnEs6T4yxPkW6WREIbs9wEKoNb3SkiM2LwRerDYtYk=;
        b=iB0fGa5/E7q9k3wPXh4+J+DerU9HRJ5jxWv1L2NLzdN5vJFdQza/5EerNmmLIOuHhj
         WrG10pZNc2WbWBf9NVpX4/gpM0F0AcxV3r0Vmc3W5C3DNwWKB7S0YLnvgiWDDDmJ2bjr
         +PFvHUfVPQFRQDoM3a+FOcnvRf1HgxJeLIgoQKjprrk035mdKkh8hs/myXrFTimOS1lb
         rUvFf1xZcBo/NDCSmWFmx8pDVtfKv1qGAWXztkKoQVoXnlGIAM2W2IaR4UIrANEBgRrC
         cehXqADZ//WcPJbgd2M4/ZFgBdIdvuUd+n4+3xSckUqR/xauz8/PkrIne7aboyaMDJ5+
         W2Wg==
X-Gm-Message-State: APjAAAVe2KMyvhaS82ih3p/6khUhCQ/mUG0+NJIDj1m+2JRbJ1T/2a4Y
        gFXcpF9KsAKXCErdyMnjx4ZqP6U=
X-Google-Smtp-Source: APXvYqwikNozvQi4R3soApB/iJlhaGuStqO4QQnVBFjrE2Ytb3ZeiZdtH/Xrt2hG/+qMMTCYJdU2HQ==
X-Received: by 2002:a5e:c247:: with SMTP id w7mr4634487iop.72.1563497695696;
        Thu, 18 Jul 2019 17:54:55 -0700 (PDT)
Received: from leira (c-68-40-189-247.hsd1.mi.comcast.net. [68.40.189.247])
        by smtp.gmail.com with ESMTPSA id s10sm79919683iod.46.2019.07.18.17.54.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 17:54:54 -0700 (PDT)
Message-ID: <219efbee81f7f22bdaf9764011cf831385837f74.camel@gmail.com>
Subject: Re: [PATCH] pnfs: Fix a problem where we gratuitously start doing
 I/O through the MDS
From:   Trond Myklebust <trondmy@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Thu, 18 Jul 2019 20:54:53 -0400
In-Reply-To: <20190719004529.2E4422173B@mail.kernel.org>
References: <20190718194039.119185-1-trond.myklebust@hammerspace.com>
         <20190719004529.2E4422173B@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Fri, 2019-07-19 at 00:45 +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: d03360aaf5cc pNFS: Ensure we return the error if
> someone kills a waiting layoutget.
> 
> The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59.
> 
> v5.2.1: Build OK!
> v5.1.18: Build OK!
> v4.19.59: Failed to apply! Possible dependencies:
>     400417b05f3e ("pNFS: Fix a typo in pnfs_update_layout")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is
> upstream.
> 
> How should we proceed with this patch?
> 

Please apply both patches.
i.e. Please apply

400417b05f3e ("pNFS: Fix a typo in pnfs_update_layout")
58bbeab425c6 ("pnfs: Fix a problem where we gratuitously start doing
I/O through the MDS")

Thanks
  Trond


