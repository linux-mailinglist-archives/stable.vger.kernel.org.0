Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC362D5248
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 21:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfJLTrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 15:47:51 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44317 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbfJLTru (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Oct 2019 15:47:50 -0400
Received: by mail-qk1-f193.google.com with SMTP id u22so12053418qkk.11
        for <stable@vger.kernel.org>; Sat, 12 Oct 2019 12:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LyLgjIQpd9IHkz3jukFR489OfWOpiz1W23vAo9b3S48=;
        b=Bu4TByBEjhUgCp6r7V1C/g8tBZAQIFowXggjW3dasrbR+2b7f1wjv/VlbgMBa3QQez
         BoYO/lILpyTFk9wPt3ntCWWfcepTpH09fIFTLc62WyAvXZXJhel4Z6iMaakxz8TPZZXl
         Qb4apAhwSF5pVEpl3VcKuq2ZghgVStGHv2+AWWArHp68kwqLUzxLbec2zdSw579sXtZT
         +b1D0/hDV+S7c12B8uz72SSzfzqX8uk6UkWwtC4mDx6e4zen4ZkeTChpQbG8HKWmLCsp
         X16aD5pC2PXeM02ns3w5I/FTLUkX4kne8FBAAjgsUI2MDYObuJKzpWAewLxBczZhLfSX
         pL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LyLgjIQpd9IHkz3jukFR489OfWOpiz1W23vAo9b3S48=;
        b=QPXcJWC9B9Oiltz0NTHM/4dc1LSiB18KAEHa43z6ZRVl4Yuy4SWEnO8KC6RIQlSpDr
         2TACBpWlHcPaHzmFauqW+ZQftfYpUb+Z05Z9xwyuiYWyW4z3OehGDJbuM6i+gCwisAzE
         cKEhpnF4CuwFvKS0XMrXZzAjp1CbyL1HNKxBPAwM/kUCVCadWzlikij3hqofrHKpwccx
         gb9Y1Mtjag3lewCc4AkF85bx1C5BuDNd4/jAxcprYDcVpKn9UY7sy2+fNrTapzWQoVDa
         K1P/sGFmLtT6diAgmH9OnsjEBLeuuZi9x6gYWeJv0fuiU4dTWQpKrEcZ7OwTu366XFhJ
         Bj7A==
X-Gm-Message-State: APjAAAWcoR87qDPCjd62u/8GlYBO0tWtiMpzKl6kbmxjipcBHHWpI0nB
        s94IjDFL75M5vgIG6nHmwxlQyA==
X-Google-Smtp-Source: APXvYqxLoB1mmC0vI9yOC+XIyA2gW62m9pCQsv2Yj65k640EskHRHLnH9qJYWZbmiiemL1JqVhXyDw==
X-Received: by 2002:a37:7ec1:: with SMTP id z184mr21279167qkc.76.1570909669635;
        Sat, 12 Oct 2019 12:47:49 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g8sm7431783qta.67.2019.10.12.12.47.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2019 12:47:48 -0700 (PDT)
Date:   Sat, 12 Oct 2019 15:47:47 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: don't needlessly create extent-refs kernel thread
Message-ID: <20191012194746.tuphjubvfeimy523@MacBook-Pro-91.local>
References: <20191012164210.17081-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012164210.17081-1-dsterba@suse.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 06:42:10PM +0200, David Sterba wrote:
> The patch 32b593bfcb58 ("Btrfs: remove no longer used function to run
> delayed refs asynchronously") removed the async delayed refs but the
> thread has been created, without any use. Remove it to avoid resource
> consumption.
> 
> Fixes: 32b593bfcb58 ("Btrfs: remove no longer used function to run delayed refs asynchronously")
> CC: stable@vger.kernel.org # 5.2+
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
