Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A750179AB8
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 22:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388280AbgCDVOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 16:14:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40065 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388053AbgCDVOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 16:14:23 -0500
Received: by mail-pf1-f194.google.com with SMTP id l184so1594526pfl.7
        for <stable@vger.kernel.org>; Wed, 04 Mar 2020 13:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5k9zbA2HFeIWJl4CKnN5cb/akw51xDynAb4nzArsnT0=;
        b=r/zes34KOwUV0ExVsKtljXF37vtqWfgKmKe7uuUDYiVgp6EeQq2aQcDvkvTpF26lNd
         ZoXO9AtQmi5G542WjhOn3p5i9RLl/xklP+9Aouwphe+bIMpo3ok2IdRGGhCDHNrN943N
         Nl1JUtpm8E4+gzNjTDu0sJo/XLgcEbp8slsK0jPGO3wIEYawSCauxRqIDD0jNAoWzlbU
         lg2WvwD3DWv2oiIM93/gCRYKwJ9Pf1ho6bQ84ThwxyLYqsSU7bWJu6caZYt7S2fL17Uf
         dZ+PlCkhwUvXMb1iyje7a6Ja/mFu+IY5GuW3Pwy4AKT1j2woGjfHcveeOjalRC9Ag0mI
         m8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=5k9zbA2HFeIWJl4CKnN5cb/akw51xDynAb4nzArsnT0=;
        b=GNstoizLYG61vALKc5F2ESrhTfVZM/6J75jLArlKpIElDMRS+cIl7tMabdpC6kINDX
         Hx29fIAGrY2o0WM2pjNHcEHNQAPEB6M+Hoo0p8V7DvDurgxMN5v4uV4MdElVyeb6Gqtf
         JJG+EREW9LTv+z1EwYu7o9sP/Ke6UlzDpfE4i/ZDcbps/IPcwoH0YNAHH7pbGQ6WQ03a
         jUoqhuZhWmxKbeNr5/QI1sIw5ClW+jFEguaI9fCm3kJSq//HZX8cFERz9euXL73+mAf5
         uhxWZIrja7+iuAMu/43LZLAwUMldDPHuA/kqq7wtS0Ig9i8l6Zdd1OJiRlXBPCimuVsN
         Y6tw==
X-Gm-Message-State: ANhLgQ0iU9pd9kI47Mm4Oa11lfQnjCBkQjc9Ax11yxDnhC8NdI071PX4
        pRk95bDCZODLTBBK3XjAcO9VP+7c
X-Google-Smtp-Source: ADFU+vvbXzaPlvTEya0cw0dyxlagDD8mBRj0mE9bNarT3iKoIxvFAJ2zMNpHsXpN0HI0RZNOOvQekg==
X-Received: by 2002:a63:1404:: with SMTP id u4mr4195620pgl.172.1583356461931;
        Wed, 04 Mar 2020 13:14:21 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gx18sm3676228pjb.8.2020.03.04.13.14.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Mar 2020 13:14:20 -0800 (PST)
Date:   Wed, 4 Mar 2020 13:14:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Qian Cai <cai@lca.pw>,
        Lech Perczak <l.perczak@camlintechnologies.com>
Subject: Regression in v4.14.172 - please revert commit 28820c5802f9
Message-ID: <20200304211419.GA30249@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

We see a regression in v4.14.172, caused by commit 28820c5802f9
("char/random: silence a lockdep splat with printk()"). I could try
to explain it, but as it turns out it was already reported for v4.19.y,
and the commit has already been reverted there. See commit cfc30449bbc50
("Revert "char/random: silence a lockdep splat with printk()") in v4.19.y
for a detailed description of the problem.

Please revert this commit in v4.14.y as well.

Thanks,
Guenter
