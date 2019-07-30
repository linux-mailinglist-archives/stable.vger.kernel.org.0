Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF917A621
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 12:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfG3KjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 06:39:19 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:47103 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfG3KjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 06:39:19 -0400
Received: by mail-wr1-f41.google.com with SMTP id z1so65171745wru.13
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 03:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BkPuPqqtjXBBicZ1H4mEBoclibVONJUG+D17KmCs5Cc=;
        b=Cc6J5pO9saOA+HoPfi76O7Bjax+DOkDqC9sNzAzKO5bQ6Z039hwv1qdxAQvKY9Qjbp
         lIALMF9RxddgoOqyjDnqR7H9xtfszD7w+OGxVCgOlOedsLo6+SRyhWRAqDabzkExetv0
         yvYOklHdUs1f6FdGk8Z4N4n3EgwP8wB7J2lw8rAU2KGPVpkFEpFiiK6S3QhFJpPSkg8i
         H66u+qAQh9UrVxQJ6tMhAAz4j2XbdRrDMUwXU1b4GLHx/bAnbdA+WQow9RXhpa9YewXx
         HsnRjzSR6n34g3cZFFrNriEh1S8XoaK++aVeJ9hmj0E86B0YKywKRSsSznlVZ8AeHhbG
         mrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=BkPuPqqtjXBBicZ1H4mEBoclibVONJUG+D17KmCs5Cc=;
        b=LnDvNHxV1DBPfi+sXKWCEShCAM0AFNshNp//kGCw21TVsdiALxNV3tQcoEs6YH31ZH
         aqcOUQ9uDPDYg6h8upWbV+Eq9nC3w+WPtpd/drF+RzTt2Sb437R1y17MYL+FNpiur881
         Ts9xQja8nD34ps25l6qPH3xSrTsxGCJ/UFusgZWMtQnlvXhsk5Cxs/4ztDR5lFR93BiX
         +dhps8jrvSxoRXdJ9m6y+v59IpRcroZiPs7LA6C4FXM5P5+WBo7K7UDvG5JNxFCl4FJs
         T+rEzJbYUxjzQ51kWG6RALMQP7NY8b7jHH2cN9AbA+6ZFy5oZFRZ14XhXbc3AK/RtlLV
         eQ/g==
X-Gm-Message-State: APjAAAW+YAWHiDmuBLRFUyo2ghp3oRZL09EsTGfQG/Lmp0NFQXZHyKt0
        EhhHgBo+z/lYBpC85kmJCEwnAnrkx8I=
X-Google-Smtp-Source: APXvYqzS4v4fim8fhFCGG0JWLS88iDxyeFIAY2JTlsjtHzA00LNfhqIFQj3cGunYjIdTu0Oujz7LYA==
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr47050681wrx.153.1564483156805;
        Tue, 30 Jul 2019 03:39:16 -0700 (PDT)
Received: from lorien (lorien.valinor.li. [2a01:4f8:192:61d5::2])
        by smtp.gmail.com with ESMTPSA id t1sm76948497wra.74.2019.07.30.03.39.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:39:16 -0700 (PDT)
Date:   Tue, 30 Jul 2019 12:39:15 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Xin Long <lucien.xin@gmail.com>
Subject: Backport request for 4.9 99253eb750fd ("ipv6: check sk sk_type and
 protocol early in ip_mroute_set/getsockopt")
Message-ID: <20190730103914.GA3114@lorien.valinor.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

As this goes to the 4.9 series according to
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-are-all-networking-bug-fixes-backported-to-all-stable-releases
I'm sending it primarily to stable@v.k.o but Cc'ing Dave and Xin Long.

Could you please apply 99253eb750fd ("ipv6: check sk sk_type and
protocol early in ip_mroute_set/getsockopt") to the 4.9 stable series?

While 5e1859fbcc3c was done back in 3.8-rc1, 99253eb750fd from
4.11-rc1 was not backported to older stable series itself, where it is
needed as well. 

Only checked if applicable without change in 4.9, but the fix should
probably go as well to the 4.4 and 3.16.

Regards,
Salvatore
