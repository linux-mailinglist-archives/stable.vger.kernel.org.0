Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B77628F4B5
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 16:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgJOO2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 10:28:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbgJOO2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 10:28:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FEKiLw138256;
        Thu, 15 Oct 2020 14:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=RyTku8xDTH+b1O5BBM7VsnPZNc0gwS1LC36OiIr+RZo=;
 b=OV7Z0VadbkjNUcUAD5i7Z7My3W5EcefsjGmu0zC5OJhPh+wvuSLxUjJcp5ZkTsVu6VIb
 PCCzPma2cRCGMmvsizqKas23qkPCNdcauoQxFibSolUZPgtsNE87JlqGyvbxZ8Pd6s3b
 gm7+rCOAY52UegyR2BbbMyhNXPfYje+Tit5wc7acPKbifkBViIRbQJZRwvuuTWVJKk9X
 WPo7xd/WlPYIRk967llAISV11LtIWAr2Pv37Gj65uiN8UJ43miDUcD2PNW8MpgcLtZB/
 An4D63u13IjEp8tWqGz3pd/AiV0hP389ytwdaiJiZmd+1LPT6sdrm67wgb1ixUT/usMK Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wkvyjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 14:28:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FEJfH7107839;
        Thu, 15 Oct 2020 14:28:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 344by58t0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 14:28:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09FESdje021772;
        Thu, 15 Oct 2020 14:28:39 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 07:28:39 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <a998d760a52f5a86343d608e34802c41977442f7.camel@hammerspace.com>
Date:   Thu, 15 Oct 2020 10:28:37 -0400
Cc:     "ashishsangwan2@gmail.com" <ashishsangwan2@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1C50A91-9948-49B8-8047-BE3FE7EF8F46@oracle.com>
References: <20201006151456.20875-1-ashishsangwan2@gmail.com>
 <2d1ff3421a88ece2f1b7708cdbc9d34b00ad3e81.camel@hammerspace.com>
 <CAOiN93mh-ssTDuN1fAptECqc5JpUHtK=1V56jY_0MtWEcT=U2Q@mail.gmail.com>
 <622f03cd08acd861a5155a181191e9ce399bbb37.camel@hammerspace.com>
 <D4D63EB4-DA04-4AAA-8A39-91987AF90E9C@oracle.com>
 <a998d760a52f5a86343d608e34802c41977442f7.camel@hammerspace.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=2 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150101
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 15, 2020, at 9:59 AM, Trond Myklebust <trondmy@hammerspace.com> =
wrote:
>=20
> On Thu, 2020-10-15 at 09:36 -0400, Chuck Lever wrote:
>>> On Oct 15, 2020, at 8:06 AM, Trond Myklebust <
>>> trondmy@hammerspace.com> wrote:
>>>=20
>>> On Thu, 2020-10-15 at 00:39 +0530, Ashish Sangwan wrote:
>>>> On Wed, Oct 14, 2020 at 11:47 PM Trond Myklebust
>>>> <trondmy@hammerspace.com> wrote:
>>>>> On Tue, 2020-10-06 at 08:14 -0700, Ashish Sangwan wrote:
>>>>>> Request for mode bits and nlink count in the
>>>>>> nfs4_get_referral
>>>>>> call
>>>>>> and if server returns them use them instead of hard coded
>>>>>> values.
>>>>>>=20
>>>>>> CC: stable@vger.kernel.org
>>>>>> Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
>>>>>> ---
>>>>>> fs/nfs/nfs4proc.c | 20 +++++++++++++++++---
>>>>>> 1 file changed, 17 insertions(+), 3 deletions(-)
>>>>>>=20
>>>>>> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
>>>>>> index 6e95c85fe395..efec05c5f535 100644
>>>>>> --- a/fs/nfs/nfs4proc.c
>>>>>> +++ b/fs/nfs/nfs4proc.c
>>>>>> @@ -266,7 +266,9 @@ const u32 nfs4_fs_locations_bitmap[3] =3D {
>>>>>>     | FATTR4_WORD0_FSID
>>>>>>     | FATTR4_WORD0_FILEID
>>>>>>     | FATTR4_WORD0_FS_LOCATIONS,
>>>>>> -     FATTR4_WORD1_OWNER
>>>>>> +     FATTR4_WORD1_MODE
>>>>>> +     | FATTR4_WORD1_NUMLINKS
>>>>>> +     | FATTR4_WORD1_OWNER
>>>>>>     | FATTR4_WORD1_OWNER_GROUP
>>>>>>     | FATTR4_WORD1_RAWDEV
>>>>>>     | FATTR4_WORD1_SPACE_USED
>>>>>> @@ -7594,16 +7596,28 @@ nfs4_listxattr_nfs4_user(struct inode
>>>>>> *inode,
>>>>>> char *list, size_t list_len)
>>>>>> */
>>>>>> static void nfs_fixup_referral_attributes(struct nfs_fattr
>>>>>> *fattr)
>>>>>> {
>>>>>> +     bool fix_mode =3D true, fix_nlink =3D true;
>>>>>> +
>>>>>>     if (!(((fattr->valid & NFS_ATTR_FATTR_MOUNTED_ON_FILEID)
>>>>>> ||
>>>>>>            (fattr->valid & NFS_ATTR_FATTR_FILEID)) &&
>>>>>>           (fattr->valid & NFS_ATTR_FATTR_FSID) &&
>>>>>>           (fattr->valid & NFS_ATTR_FATTR_V4_LOCATIONS)))
>>>>>>             return;
>>>>>>=20
>>>>>> +     if (fattr->valid & NFS_ATTR_FATTR_MODE)
>>>>>> +             fix_mode =3D false;
>>>>>> +     if (fattr->valid & NFS_ATTR_FATTR_NLINK)
>>>>>> +             fix_nlink =3D false;
>>>>>>     fattr->valid |=3D NFS_ATTR_FATTR_TYPE |
>>>>>> NFS_ATTR_FATTR_MODE |
>>>>>>             NFS_ATTR_FATTR_NLINK |
>>>>>> NFS_ATTR_FATTR_V4_REFERRAL;
>>>>>> -     fattr->mode =3D S_IFDIR | S_IRUGO | S_IXUGO;
>>>>>> -     fattr->nlink =3D 2;
>>>>>> +
>>>>>> +     if (fix_mode)
>>>>>> +             fattr->mode =3D S_IFDIR | S_IRUGO | S_IXUGO;
>>>>>> +     else
>>>>>> +             fattr->mode |=3D S_IFDIR;
>>>>>> +
>>>>>> +     if (fix_nlink)
>>>>>> +             fattr->nlink =3D 2;
>>>>>> }
>>>>>>=20
>>>>>> static int _nfs4_proc_fs_locations(struct rpc_clnt *client,
>>>>>> struct
>>>>>> inode *dir,
>>>>>=20
>>>>> NACK to this patch. The whole point is that if the server has a
>>>>> referral, then it is not going to give us any attributes other
>>>>> than
>>>>> the
>>>>> ones we're already asking for because it may not even have a
>>>>> real
>>>>> directory. The client is required to fake up an inode, hence
>>>>> the
>>>>> existing code.
>>>>=20
>>>> Hi Trond, thanks for reviewing the patch!
>>>> Sorry but I didn't understand the reason to NACK it. Could you
>>>> please
>>>> elaborate your concern?
>>>> These are the current attributes we request from the server on a
>>>> referral:
>>>> FATTR4_WORD0_CHANGE
>>>>> FATTR4_WORD0_SIZE
>>>>> FATTR4_WORD0_FSID
>>>>> FATTR4_WORD0_FILEID
>>>>> FATTR4_WORD0_FS_LOCATIONS,
>>>> FATTR4_WORD1_OWNER
>>>>> FATTR4_WORD1_OWNER_GROUP
>>>>> FATTR4_WORD1_RAWDEV
>>>>> FATTR4_WORD1_SPACE_USED
>>>>> FATTR4_WORD1_TIME_ACCESS
>>>>> FATTR4_WORD1_TIME_METADATA
>>>>> FATTR4_WORD1_TIME_MODIFY
>>>>> FATTR4_WORD1_MOUNTED_ON_FILEID,
>>>>=20
>>>> So you are suggesting that it's ok to ask for SIZE, OWNER, OWNER
>>>> GROUP, SPACE USED, TIMESTAMPs etc but not ok to ask for mode bits
>>>> and
>>>> numlinks?
>>>=20
>>> No. We shouldn't be asking for any of that information for a
>>> referral
>>> because the server isn't supposed to return any values for it.
>>>=20
>>> Chuck and Anna, what's the deal with commit c05cefcc7241? That
>>> appears
>>> to have changed the original code to speculatively assume that the
>>> server will violate RFC5661 Section 11.3.1 and/or RFC7530 Section
>>> 8.3.1.
>>=20
>> The commit is an attempt to address the many complaints we've had
>> about the ugly appearance of referral anchors. The strange "special"
>> default values made the client appear to be broken, and was confusing
>> to some. I consider this to be a UX issue: the information displayed
>> in this case is not meant to be factual, but rather to prevent the
>> user concluding that something is wrong.
>>=20
>> I'm not attached to this particular solution, though. Does it make
>> sense to perform the referral mount before returning "ls" results
>> so that the target server has a chance to supply reasonable
>> attribute values for the mounted-on directory object? Just spit
>> balling here.
>>=20
>>=20
>>> Specifically, the paragraph that says:
>>>=20
>>> "
>>>  Other attributes SHOULD NOT be made available for absent file
>>>  systems, even when it is possible to provide them.  The server
>>> should
>>>  not assume that more information is always better and should
>>> avoid
>>>  gratuitously providing additional information."
>>>=20
>>> So why is the client asking for them?
>>=20
>> This paragraph (and it's most modern incarnation in RFC 8881 Section
>> 11.4.1) describes server behavior. The current client behavior is
>> spec-compliant because there is no explicit prohibition in the spec
>> language against a client requesting additional attributes in this
>> case.
>>=20
>> Either the server can clear those bitmap flags on the GETATTR reply
>> and not supply those attributes, and clients must be prepared for
>> that.
>>=20
>> Or, it's also possible to read this paragraph to mean that the
>> server can provide those attributes and the values should not
>> reflect attributes for the absent file system, but rather something
>> else (eg, server-manufactured defaults, or the attributes from the
>> object on the source server).
>>=20
>> And since this is a SHOULD NOT rather than a MUST NOT, servers are
>> still free to return information about the absent file system.
>> Clients are not guaranteed this will be the case, however.
>>=20
>> I don't think c05cefcc7241 makes any assumption about whether the
>> server is lying about the extra attributes. Perhaps the server has
>> no better values for these attributes than the client's defaults
>> were.
>>=20
>=20
> SHOULD / SHOULD NOT indicates actions that the server is required to
> take in the absence of a very good reason to do otherwise. In other
> words, the client should expect the majority of servers to behave in a
> certain manner.
>=20
> It doesn't matter that the client's behaviour is spec compliant. We're
> asking for information that is not supposed to be divulged by the
> majority of servers,

We might be reading the spec differently.

I read that SHOULD NOT as saying the server should not hand out
attributes for the absent file system, not that it shouldn't
hand out attributes at all. My experience at that time was that
servers handed out attributes for the referral object that was
present on that server. That seems to be completely allowed by
the spec language.

But you're correct: it's not relevant to application behavior.
As I said, it's merely to prevent users from deciding the Linux
client is somehow not working right.

We're working around the client's behavior: it doesn't follow
the referral until after a user cd's into that directory. Thus
the typical pattern of

$ ls
$ cd

Gives surprising results.


> Furthermore, that information is, quite frankly,
> utterly irrelevant to the client and application running on it. Any
> attempt to access that fake object will result in a submount of
> something completely different on top of that object.
>=20
> IOW: the only difference here is you're asking that the server provide
> us with a faked up object (which it is not supposed to do), whereas
> previously, we were faking that object up ourselves. What's the big
> deal here?


--
Chuck Lever



