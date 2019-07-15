Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E979268619
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 11:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfGOJOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 05:14:15 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:49020 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729257AbfGOJOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 05:14:14 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 620B52E0A3D;
        Mon, 15 Jul 2019 12:14:12 +0300 (MSK)
Received: from smtpcorp1p.mail.yandex.net (smtpcorp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:10])
        by mxbackcorp1g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id pcUTODv2sn-ECtm18As;
        Mon, 15 Jul 2019 12:14:12 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1563182052; bh=6Z0MAYYXDs0jmkOa22U2ufYCUQvOZxaBpllK1/m6kp0=;
        h=Date:Message-ID:Subject:From:To:Cc;
        b=fxi0Vy1HNIDBYd/E0b0tLqUNTM6b7PKgqiVROKipPQBAbY1dU3car4k+AZLXVy7i1
         LPCT4BlxIC2Ens4DOjqoMgKmW7n3rk2WrzlegqxTA9U/w3TpTn3A9hvq07Qzqh2obf
         aPgIMT40GcQKS2bBjl53UzEZiYWFxqyrSoEWU9fU=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:38c5:1c4f:8e20:cf1b])
        by smtpcorp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id 5WpVhKFN9v-ECwaotcq;
        Mon, 15 Jul 2019 12:14:12 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
To:     Stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: drivers/e1000e revert and proper fix
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Message-ID: <667a1815-df93-3072-8042-c4efb37bc81a@yandex-team.ru>
Date:   Mon, 15 Jul 2019 12:14:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pick revert-commit

commit caff422ea81e144842bc44bab408d85ac449377b
("Revert "e1000e: fix cyclic resets at link up with active tx"")

and (optionally) proper fix

commit d17ba0f616a08f597d9348c372d89b8c0405ccf3
("e1000e: start network tx queue only when link is up")

into 4.9, 4.14, 4.19, 5.1, 5.2

buggy commit 0f9e980bf5ee1a97e2e401c846b2af989eb21c61
("e1000e: fix cyclic resets at link up with active tx")
commited in 5.0 and was picked into 4.9, 4.14, 4.19

It generates annoying false-positive hung-hardware warnings
https://bugzilla.kernel.org/show_bug.cgi?id=203175

Original problem isn't so severe so feel free to skip second commit if it doesn't apply clearly.
