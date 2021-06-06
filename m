Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA4A39CEA7
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 13:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhFFLMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 07:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFFLMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 07:12:20 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832D6C061766
        for <stable@vger.kernel.org>; Sun,  6 Jun 2021 04:10:30 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 5F836300002D0;
        Sun,  6 Jun 2021 13:10:28 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 532441EDD; Sun,  6 Jun 2021 13:10:28 +0200 (CEST)
Date:   Sun, 6 Jun 2021 13:10:28 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.12 03/43] spi: Fix spi device unregister flow
Message-ID: <20210606111028.GA20948@wunner.de>
References: <20210603170734.3168284-1-sashal@kernel.org>
 <20210603170734.3168284-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603170734.3168284-3-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 01:06:53PM -0400, Sasha Levin wrote:
> From: Saravana Kannan <saravanak@google.com>
> 
> [ Upstream commit c7299fea67696db5bd09d924d1f1080d894f92ef ]

This commit shouldn't be backported to stable by itself, it requires
that the following fixups are applied on top of it:

* Upstream commit 27e7db56cf3d ("spi: Don't have controller clean up spi
  device before driver unbind")

* spi.git commit 2ec6f20b33eb ("spi: Cleanup on failure of initial setup")
  https://git.kernel.org/broonie/spi/c/2ec6f20b33eb

Note that the latter is queued for v5.13, but hasn't landed there yet.
So you probably need to back out c7299fea6769 from the stable queue and
wait for 2ec6f20b33eb to land in upstream.

Since you've applied c7299fea6769 to v5.12, v5.10, v5.4, v4.14 and v4.19
stable trees, the two fixups listed above need to be backported to all
of them.

Thanks,

Lukas
