Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10746E99
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 08:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfFOG2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 02:28:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39008 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfFOG2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 02:28:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so4218951wma.4;
        Fri, 14 Jun 2019 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3zLySgCclFnvuNTV15P6TA3DxfDKWG9jw7Y0vYK7J1Q=;
        b=o09zssjCRBBimQ6/BNdXPY/DozFzaYTRjxHgnUrOeK6avOcGfo8g8b0G71c+4BuXDG
         tYRgLXUdZSUOFY2dnsC4rH6O6DKv0NsGFCa37xaaBWgHyu8vBgtjDDpW3Wx+Wzf4kec+
         FTGlpmrsaiJd1dcCzCeFLI5b+mgn96bRU0ip5vAbwE/EuWPa+aR5z20NSJCz7odIBJuJ
         whi4+Pp6HdDuZXQ8L5CQ/BXpiX+9N3VkYBDnOiY6BaeHRtlvpYEgmx9ttP+TYM+PAMLc
         3Ny+fbxlBzyZghsuN15DT0+RYj2J6uYBCsaw9QmzvBiI/GZtgVhGTTuT1h8mOEEQ591z
         1GCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3zLySgCclFnvuNTV15P6TA3DxfDKWG9jw7Y0vYK7J1Q=;
        b=Gyyua74nRYfYnbuJPfy9TowuXeaqBiy/MyIurtjbPTkzpOvDTXepVRnG0TvnYzyo8q
         DnXaPH9toQzfDRxy8Q07fCbTE4vUjid5vhxsBKt4TTe8lwEB4aIN/0w2hxh3gZHrvNxQ
         9W5m/KA+dbpPCJmnsoY2WSELbihLbKuRHMXUUXt1bDpWX1OOcxieDqTkw7qS6WnJP5jH
         IKtVugx3fFfGHcJ3Q+/KrRROPy5qPI4bk47PcrC4UtF0zHNk8dVE2ADBOb8qvQ4gTxw8
         uuPY03zePX6XrKFUrw2n+5lpzG4zczi57l1msO8GUzsEEGg+i6EFvPFWEJ10wpSaYKBi
         VI+Q==
X-Gm-Message-State: APjAAAW19uK9Wltg86WtqvlKXU+Q/aLfsvUteLkH+xFsRamfvGhg+VHH
        SgJBDkLdzBzRuY6RYNjT1rX9GTceOuHdxA==
X-Google-Smtp-Source: APXvYqzFMXUG7FDAKz7YOvOYfDx0LdUjaKO3QWNufslY/7C+5+Oh+Hv0ZtRgOAg0LGIOeWfKmmPllA==
X-Received: by 2002:a1c:c8:: with SMTP id 191mr10552594wma.6.1560580132093;
        Fri, 14 Jun 2019 23:28:52 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id f197sm6027911wme.39.2019.06.14.23.28.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 23:28:51 -0700 (PDT)
Subject: Re: [PATCH] tpm: Fix null pointer dereference on chip register error
 path
To:     Sasha Levin <sashal@kernel.org>, linux-integrity@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20190612084210.13562-1-gmazyland@gmail.com>
 <20190614215635.2D9BD2184E@mail.kernel.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <251208d1-96f9-1fab-3fee-4a216ff87f5e@gmail.com>
Date:   Sat, 15 Jun 2019 08:28:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614215635.2D9BD2184E@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/06/2019 23:56, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all

It should be only # v5.1+

And seems I also forgot to add some cc for the original patch, sorry.

The referenced patch is here
https://lore.kernel.org/linux-integrity/20190612084210.13562-1-gmazyland@gmail.com/

Milan
